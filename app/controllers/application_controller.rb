# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'digest/md5'
require 'openssl'

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
#  before_filter :set_login
  include ExceptionNotifiable
  protected

    def email_report
        puts "Sending email report..."
        beginning = "<table>"
        heading="<center><tr><td>order_no</td><td>status</td>" +
                "<td>timestamp</td></tr><br/></center>"
        ending = "</table>"
        error_list = beginning + heading;
        query = 'SELECT * FROM as_loggers WHERE created_at'
        errors = AsLogger.all#(:conditions => {:created_at => (Time.now - 1.day)})
        for error in errors
           puts "Error: " + error.status
           next if error.status.include? "FIX_CC" #don't include fix_cc entries
           error_list << "<tr><td>" + error.order_no + "</td>" + 
                        "<td>" + error.status + "</td>" + 
                        "<td>" + error.created_at.to_s + "</td></tr>"
        end
        error_list << ending
        SendEmail.deliver_error_report(error_list)
        #TODO finish
        redirect_to :controller => 'sessions', :action => 'new'
    end

    def generate_email_code() #TODO Should be moved to a separate utility class
        return Digest::MD5.hexdigest("#{Time.now}#{random_string(40)}")
    end

    def random_string(size=16) #TODO Should be moved to a separate utility class
        s = ""
        size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
        return s
    end

    def process_single_cc(client, send_email=SEND_EMAIL)
      total = get_total(client)
      customer_code = client.customer_no.to_s.empty? ? "0" : client.customer_no.to_s
      sales_tax = client.tax_value.to_s.empty? ? "0" : client.tax_value.to_s
      month = client.validity_month.to_s
      month = "0" + month if month.length == 1
      number = PRIVATE_KEY.private_decrypt(client.cc_number)

      target = CC_LOGIN + "ssl_card_number=" << number.to_s << "&" +
      "ssl_exp_date=" << month <<
                      client.validity_year.to_s[2,3] << "&" +
      "ssl_amount=" << total.to_s << "&" +
      "ssl_salestax=" << sales_tax << "&" +
      "ssl_customer_code=" << customer_code << "&" +
      "ssl_show_form=false&" +
      "ssl_cvv2cvc2_indicator=1&" +
      "ssl_cvv2cvc2=" << client.cvc_cvv.to_s << "&" +
      "ssl_avs_address=" << client.billing_address << "&" +
      "ssl_avs_zip=" << client.billing_zipcode.to_s.delete("-") << "&" +
      "ssl_result_format=ASCII&" +
      "ssl_invoice_number=" << client.order_no.to_s

      uri = URI.parse(CC_URL)
      http_session = Net::HTTP.new(uri.host, uri.port)
      http_session.use_ssl = true
      res = http_session.start { |http|
         http.post(CC_TARGET_HEADER, target);
      }
      client.cc_log = Time.now.to_s+":<br/>\n"+res.body+
                     "<br/>\n---------<br/>\n"+client.cc_log
      lines = res.body.split("\n");
      approval = "ssl_approval_code="
      error = "errorCode="
      #check if it was approved
      if res.body.include? "APPROVAL"
         #approved!
         client.cc_result = "Approved"
         client.status = "payment processed"
         client.save
         update_status(client, "payment processed")
         lines.each { |line|
            if(line.index(approval) != nil)
               client.cc_code = line[approval.length,line.length-1]
               break
            end
         }
      else
         #denied
         client.cc_result = "Denied"
         client.status = "payment denied"
         client.save
         update_status(client, "payment denied")
         #find error code
         lines.each { |line|
            if(line.index(error) != nil)
               client.cc_code = line[error.length,line.length-1]
               break
            end
         }
      end
      client.save
      SendEmail.deliver_invalid_cc(client) if send_email and client.cc_result == 'Denied'
  end
  
  def get_total(client)
    query = "SELECT * from clients WHERE order_no LIKE '" + client.order_no + "~%'"
    clients = Client.find_by_sql query
    total = client.total;
    clients.each {|unit| total += unit.total }
    return total
  end

  def update_status(client, status)
    if client.order_no.include? '~'
       order_no = client.order_no[0,client.order_no.index('~')]
    else
       order_no = client.order_no
    end
    query = "SELECT * from clients WHERE order_no LIKE '" + order_no + "%'"
    clients = Client.find_by_sql query
    clients.each {|subclient|
       subclient.status = status
       subclient.save
    }
    client.save
  end



  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
