require 'csv'
require 'fastercsv'
require 'net/http'
require 'net/https'

class ShippingController < ApplicationController
  before_filter :login_required
  require_role ["shipper"]
  layout 'main'
  def index
    @clients = (params[:show_shipped] ? Client.all : Client.all(:conditions => "status NOT LIKE 'shipped'"))
    #update status code
    @clients.each do |client|
      client.status_code = case client.status
         when "new" then 1
         when "backorder" then 2
         when "payment error" then 3
		 when "shipping error" then 4
         when "payment processed" then 5
         when "payment pending" then 6
         when "shipping pending" then 7
         when "shipped" then 8
         else 0
      end
      client.save
    end
    #@clients = @clients.sort_by { |x| [x.status_code, x.order_no]}
	@clients  = @clients.sort do |a,b|
		if a.status_code == b.status_code
			if a.order_no.include? b.order_no or b.order_no.include? a.order_no
				a.order_no <=> b.order_no
			else
			b.order_no <=> a.order_no
			end
		else
			a.status_code <=> b.status_code 
		end
   	 end
  end

  def single_view
    @entry = Client.find(params[:id])
  end

  def edit_client
    client = Client.find(params[:id])
    client.update_attributes(params[:client])
    client.save
    #update status for all parts of the order
    update_status(client, client.status)
    redirect_to :action => :index
  end

  def encrypt_cc_numbers
    clients = Client.all
    for client in clients
      next if client.cc_number == nil
      client.cc_number = PUBLIC_KEY.public_encrypt(client.cc_number)
      client.save
      end
  end

  def process_cc
    while Client.exists?(:status => "new")
      client = Client.find(:first, :conditions => {:status => "new"})
      client.status = "payment pending"
      update_status(client, "payment pending")
      unless client.order_no.include? "~"
         process_single_cc(client)
      end
    end
    redirect_to :action => :index
  end

  def export
    @to_export=Client.find(:all,:conditions=>{:status =>"payment processed"})
    @outfile= "shipping_labels_" + Time.now.strftime("%Y-%m-%d--%H-%M") + ".csv"
    
    csv_data = FasterCSV.generate do |csv|
      @to_export.each do |client|
      next if client.order_no.include?('~')
	  address = ""
      if client.shipping_address.empty? 
         address << client.title+" "+client.billing_first_name+" "+client.billing_name+"\n"
         address << client.billing_address
         address << (client.billing_address2.empty? ? "" : ", " + client.billing_address2)
         address << "\n" 
         address << client.billing_city+ ", " unless client.billing_city.nil?
		 address << client.billing_state+" " unless client.billing_state.nil?
		 address << client.billing_zipcode unless client.billing_zipcode.nil?
         address << "\n"+client.billing_country
      else
         address << client.shipping_title+" "+client.shipping_first_name+" "
         address << client.shipping_name+"\n" 
         address << client.shipping_address
         address << (client.shipping_address2.empty? ? "" : ", " + client.shipping_address2) 
         address << "\n" 
         address << client.shipping_city+", " unless client.shipping_city.nil?
		 address << client.shipping_state+" " unless client.shipping_state.nil?
		 address << client.shipping_zip_code unless client.shipping_zip_code.nil?
         address << "\n"+client.shipping_country
      end 
	  csv << [address]
      update_status(client, "shipping pending")
    end
    end
    send_data csv_data, 
      :type => 'text/csv; charset=iso-8859-1',
      :disposition => "attachment; filename=#{@outfile}"
  end

  def customer_list
    to_export=Client.find(:all,:conditions=>{:status =>"shipping pending"})
    outfile= "customer-product_list"+Time.now.strftime("%Y-%m-%d--%H-%M")+".csv"
    
    csv_data = FasterCSV.generate do |csv|
      to_export.each do |client|
         next if client.order_no.include?('~')
         units = get_items(client)
         if not client.shipping_address.empty?
      	    csv << [
               client.shipping_first_name + " " + client.shipping_name,
               client.shipping_country, units
            ]
         else
            csv << [
               client.billing_first_name + " " + client.billing_name,
               client.billing_country, units
            ]
         end
      update_status(client, "shipped");
      end
    end
    send_data csv_data, 
      :type => 'text/csv; charset=iso-8859-1',
      :disposition => "attachment; filename=#{outfile}"
  end

  def delete
      query="SELECT id FROM clients WHERE order_no LIKE '"+params[:order_no]+"%'"
      ids = Client.find_by_sql query
      Client.destroy(ids)
      redirect_to :action => :index
  end

  def get_items(client)
      items = ""
      query = "SELECT * from clients WHERE order_no LIKE '"+client.order_no+"%'"
      orders = Client.find_by_sql query
      first = true;
      orders.each do |order|
         items << (first ? "" : "\n") + order.product_title
         first = false
      end
      return items;
  end

  def get_item_info(client)
      items = []
      query = "SELECT * from clients WHERE order_no LIKE '"+client.order_no+"%'"
      orders = Client.find_by_sql query
      orders.each do |order|
         items << [order.item_no, order.amount]
      end
      return items;
  end

  def webgistix
    orders=Client.find(:all,:conditions=>{:status =>"payment processed"})
    orders.each do |order|
        next if order.order_no.include?('~')
        order.status = "processing webgistix"
        order.save
        update_status(order, "processing webgistix")
        webgistix_single(order)
    end
    redirect_to :action => :index
  end

  def webgistix_single(client)
     if not client.shipping_name.empty? 
        name = client.shipping_first_name + " " + client.shipping_name
        address1 = client.shipping_address 
        address2 = client.shipping_address2
        city = client.shipping_city
        state = client.shipping_state
        zip = client.shipping_zip_code
        country = client.shipping_country
        email = client.email # client.email = shipping_email
        phone = client.phone # ditto above
     else
        name = client.billing_first_name + " " + client.billing_name
        address1 = client.billing_address + 
        address2 = client.billing_address2
        city = client.billing_city
        state = client.billing_state
        zip = client.billing_zipcode
        country = client.billing_country
        email = client.billing_email
        phone = client.billing_phone
     end
     items = format_items(client)
     target = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
            "<OrderXML>" + WEBGISTIX_LOGIN_INFO + 
            "<Order>" + 
	            "<ReferenceNumber>" +client.order_no+ "</ReferenceNumber>" + 
	            "<Name>" + name + "</Name>" + 
	            "<Address1>" + address1 + "</Address1>" + 
	            "<Address2>" + address2 + "</Address2>" + 
	            "<Address3></Address3>" + 
	            "<City>" + city + "</City>" + 
	            "<State>" + state + "</State>" + 
	            "<ZipCode>" + zip + "</ZipCode>" + 
	            "<Country>" + country + "</Country>" + 
	            "<Email>" + email + "</Email>" + 
	            "<Phone>" + phone + "</Phone>" + 
               #TODO CANADA!
	            "<ShippingInstructions>Ground</ShippingInstructions>" + 
	            "<OrderComments></OrderComments>" + #TODO anything here?
	            "<Approve>1</Approve>" + 
               items +
            "</Order>" + 
            "</OrderXML>"


     uri = URI.parse(WEBGISTIX_URL)
     http_session = Net::HTTP.new(uri.host, uri.port)
     http_session.use_ssl = false #TODO only for now...
     res = http_session.start { |http|
        http.post(WEBGISTIX_HEADER, target);
     }

     check_webgistix_result(client, res.body)
        
  end


  def check_webgistix_result(client, result)
     # check if successful
     if result.include? "<Completed>"
        client.webg_result = "Success"
        update_status(client, "shipping pending")
        # get Webgistix's orderID, check for backorder
        if result.include? "<Success>True</Success>"
           result[/<OrderID>(.*?)<\/OrderID>/]
           client.webg_order_code = $1
           result[/<BackOrder>(.*?)<\/BackOrder>/]
           if $1 == "True"
              client.webg_result = "backorder"
              update_status(client, "backorder")
           end
        end
     else
        client.webg_result = "Failure"
        update_status(client,  "shipping error")
        logger = AsLogger.new
        logger.order_no = client.order_no
        logger.status = "WEBGISTIX: failed. result: " + result
        logger.save
     end

     # check for errors
     if result.include? "<Errors>" 
        client.webg_error = true;
     else
        client.webg_error = false;
     end

     # add entire response to log with timestamp (like cc_log)
	 # <xmp> tag is so that browsers won't try to render the XML in the result
     client.webg_log = Time.now.to_s + "<br/>\n<xmp>" + result + 
                       "</xmp><br/>\n-----------<br/>\n" + client.webg_log
     client.save
  end

  def query_webgistix_orders
    order_ids = ""
    orders=Client.find(:all,:conditions=>{:status =>"shipping pending"})
    beginning = "<Tracking><Order>"
    ending = "</Order></Tracking>"
    orders.each do |order|
        next if order.order_no.include?('~')
        order_ids << (beginning + order.order_no + ending)
    end
    check_webgistix_orders(order_ids) unless order_ids == ""
    redirect_to :action => :index
  end

  def check_webgistix_orders(orders)
     target = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + 
     "<TrackingXML>" + WEBGISTIX_LOGIN_INFO + orders + "</TrackingXML>"
     
     uri = URI.parse(WEBGISTIX_URL)
     http_session = Net::HTTP.new(uri.host, uri.port)
     http_session.use_ssl = false #TODO only for now...
     res = http_session.start { |http|
        http.post(WEBGISTIX_TRACKING_HEADER, target);
     }
     process_tracking_results(res.body)
     
  end

  def process_tracking_results(results)
     # look at each response
     shipments = results.scan(/<Shipment>(.*?)<\/Shipment>/)
     for shipment_part in shipments
	 	 shipment = shipment_part[0]
		 if shipment.include? "<Error>"
			AsLogger.create :order_no => '0', :status => "Error in webgistix result. Message: #{shipment}"
			next
		 end
         shipment =~ /<ShipmentTrackingNumber>(.*?)<\/ShipmentTrackingNumber>/
         tracking = $1
         # if it's still not shipped, we're done here...
         next if tracking == "Not Shipped"
         # update status if necessary
         shipment =~ /<InvoiceNumber>(.*?)<\/InvoiceNumber>/
         order_no = $1
         shipment =~ /<DateShipped>(.*?)<\/DateShipped>/
         shipdate = $1
         # find respective order
         client = Client.first(:conditions => {:order_no => order_no})
         client.tracking_no = tracking
         client.ship_date = shipdate
         update_status(client, "shipped")
         client.save
     end
     
  end

  def format_items(client)
     result = ""
     beginning = "<Item><ItemID>"
     middle = "</ItemID><ItemQty>"
     ending = "</ItemQty></Item>"
     items = get_item_info(client)
     items.each do |item| 
        id = get_sku(item[0])
        next if id == nil
        result << (beginning + id + middle + item[1] + ending)
     end
     return result
  end

  def get_sku(item_no)
     query = "SELECT sku FROM sku_lookups WHERE item_no='" + item_no + "'"
     responses = SkuLookup.find_by_sql query
     if responses.length != 1
        logger = AsLogger.new
        logger.order_no = "0"
        logger.status = "GET_SKU: FAILED to get 1-1 matching for item no: " +
                item_no+", instead found: "+responses.length.to_s+" matches"
        logger.save
        return '0'
     end
     return SKU_PREFIX + responses[0].sku
  end 
end
