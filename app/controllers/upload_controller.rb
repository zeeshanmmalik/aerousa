require 'csv'
class UploadController < ApplicationController
  before_filter :login_required
  require_role ["uploader"]
  layout 'main'
  def index
  end

  
  def import_csv
      if request.post?
            unless params[:data][:datafile].blank?
                 parsed_file=CSV::Reader.parse(params[:data][:datafile])
                 header_ignored = false
                 count=0
                 @orders=0
                 previous = Client.new
                 $errors = Array.new
                 parsed_file.each do |row|
                      unless header_ignored
                        header_ignored = true
                        next
                      end
                      #if there's no order number, entry belongs to previous
                      client = Client.new
                      error = false;

                      next if row[36].to_s.strip.empty? #we have a blank row

                      if row[0].to_s.strip.empty? 
                         count = count + 1
                         client.order_no = (previous.order_no + "~" + count.to_s)
                         client.email_code = previous.email_code
                      else
                         count = 0;
                         client.email_code = generate_email_code
                         client.order_no = row[0].to_s.strip
                         client.order_date = row[1].to_s.strip
                         client.customer_no = row[2].to_s.strip
                         client.title = row[3].to_s.strip
                         client.billing_first_name = row[4].to_s.strip
                         client.billing_name = row[5].to_s.strip
                         client.billing_company = row[6].to_s.strip
                         client.billing_address = row[7].to_s.strip
                         client.billing_address2 = row[8].to_s.strip
                         client.billing_country = row[9].to_s.strip
                         client.billing_zipcode = row[10].to_s.strip
                         client.billing_city = row[11].to_s.strip
                         state = row[12].to_s.strip
                         client.billing_state = checkState(state[state.length-3,2])
                         client.billing_email = row[13].to_s.strip
                         client.billing_fax = row[14].to_s.strip
                         client.billing_phone = row[15].to_s.strip
                         client.shipping_title = row[16].to_s.strip
                         client.shipping_first_name = row[17].to_s.strip
                         client.shipping_name = row[18].to_s.strip
                         client.shipping_company = row[19].to_s.strip
                         client.shipping_address = row[20].to_s.strip
                         client.shipping_address2 = row[21].to_s.strip
                         client.shipping_country = row[22].to_s.strip
                         client.shipping_zip_code = row[23].to_s.strip
                         client.shipping_city = row[24].to_s.strip
                         state = row[25].to_s.strip
                         client.shipping_state = checkState(state[state.length-3,2])
                         client.email = row[26].to_s.strip
                         client.fax = row[27].to_s.strip
                         client.phone = row[28].to_s.strip
                         client.shipping = row[29].to_s.strip
                         client.payment = row[30].to_s.strip
                         client.credit_card = row[31].to_s.strip
                         cc_number = row[32].to_s.strip
                         client.cc_number = PUBLIC_KEY.public_encrypt(cc_number)
                         client.validity_month = row[33].to_s.strip
                         client.validity_year = row[34].to_s.strip
                         client.cvc_cvv = row[35].to_s.strip
                         # TODO check up on this...
                         error = error || check_main_entry(client)
                         unless error 
                            @orders = @orders + 1
                         end
                         #only reassign previous on a new order
                         previous = client
                      end
							 client.status = "new"
                      client.status_code = "1" # new --> 1
                      client.item_no = row[36].to_s.strip
                      client.amount = row[37].to_s.strip
                      client.product_title = row[38].to_s.strip
                      client.price = row[39].to_s.strip.sub('$','')
                      client.shipping_costs = row[40].to_s.strip.sub('$','')
                      client.tax = row[41].to_s.strip
                      client.tax_value = row[42].to_s.strip.sub('$','')
                      client.total = row[43].to_s.strip.sub('$','')
                      client.comment = row[44].to_s.strip
                      client.cc_result = "Unprocessed"
                      client.cc_code = "0"
                      client.cc_log = " "
                      client.webg_log = " "
                      error = error || check_product_info(client)
                      unless error 
                         client.save
                      end
                  end
                  if $errors.empty?
                     @message = "CSV file has been imported successfully."
                  else
                     @message = "The following errors were found during data
                                 validation: "
                  end
            end
            
          end
  end

  def checkState(state)
    #fix bug in shop, where Quebec (QC)'s code was listed as PO
    return (state == "PO" ? "QC" : state)
  end

  def check_main_entry(client)
   error = false; 
   if client.billing_address.empty?
      $errors << ("Order #: " << client.order_no <<
                ", billing address missing")
      error = true
   end
   number = PRIVATE_KEY.private_decrypt(client.cc_number)
   if client.payment.eql?("KKarte") &&
         (number.length < 13 || number.length > 16)
      $errors << ("Order#: " << client.order_no <<
                ", invalid format for credit card number")
      error = true
   end

   if client.validity_month.length != 2 || client.validity_year.length != 4
      $errors << ("Order #: " << client.order_no <<
                  ", credit card validity date must be of form MM, YYYY")
      error = true
   end
   if client.billing_country.eql?("United States") &&
         client.billing_zipcode.length != 5 && client.billing_zipcode.length != 10
      $errors << ("Order #: " << client.order_no <<
                  ", zip code of improper length")
      error = true
   end

   return error
  end

  def check_product_info(client)
    #TODO
    return false; 
  end
  
end


