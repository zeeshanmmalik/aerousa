class SupportController < ApplicationController
  CC_RETRIES_PER_DAY = 10
  
  def fix_cc
      @units = Client.find_all_by_email_code_and_status(params[:code].to_s, 'payment denied')
      @client = Client.find_by_email_code_and_status(params[:code].to_s, 'payment denied')
      @total_price = get_total(@client) unless @client.blank?
      @show_details = true
      aslogger = AsLogger.new
      if @client.blank?
          flash.now[:message] = "Your code is incorrect or expired."
          aslogger.order_no = '0'
          aslogger.status = "FIX_CC: Invalid code : #{params[:code]}"
          @show_details = false
          aslogger.save
      elsif @client.attempt_count >= CC_RETRIES_PER_DAY
          flash.now[:message] = "Sorry, you've tried too many times today. Please try again tomorrow."
          aslogger.status = "FIX_CC: Retries exceeded : #{params[:code]}"
          aslogger.order_no = @client.order_no
          @show_details = false
          aslogger.save
      elsif (request.put? or request.post?)
          @client.attempt_count += 1
          @client.update_info(params[:client])
          process_single_cc(@client, false)
          aslogger.order_no = @client.order_no
          if @client.cc_result == 'Approved'
              @show_details = false
              aslogger.status = "FIX_CC: Success : #{params[:code]}"
              flash.now[:message] = "Thank you, your card has been successfully charged. We will ship your order now. It should leave our warehouse within 24 hours and arrive at your destination within 2-5 business days."
          else
              aslogger.status = "FIX_CC: Failed : #{params[:code]}"

              flash.now[:message] = " We're sorry, but your payment information was declined. Please try again."
          end
          aslogger.save
      else # just opened the page -- hasn't changed any info yet
         # populate shipping info if it wasn't provided
         populate_shipping_info
      end
      render :layout => 'email'
  end

  def populate_shipping_info
      if @client.shipping_address.empty?
         #copy stuff in here...
         @client.shipping_title = @client.title
         @client.shipping_first_name = @client.billing_first_name
         @client.shipping_name = @client.billing_name
         @client.shipping_company = @client.billing_company
         @client.shipping_address = @client.billing_address
         @client.shipping_address2 = @client.billing_address2
         @client.shipping_country = @client.billing_country
         @client.shipping_zip_code = @client.billing_zipcode
         @client.shipping_city = @client.billing_city
         @client.shipping_state = @client.billing_state
         @client.email = @client.billing_email
         @client.fax = @client.billing_fax
         @client.phone = @client.billing_phone
         @client.save
      end
  end

end
