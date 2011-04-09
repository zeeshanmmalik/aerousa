class Client < ActiveRecord::Base
  validates_presence_of :order_no
  validates_uniqueness_of :order_no
#  validates_presence_of :pos, :order_no, :order_date,
#      :customer_no, :title, :billing_first_name, :billing_name,
#      :billing_company,
#      :billing_address, :billing_address2, :billing_country, :billing_zipcode,
#      :billing_city, :billing_state, :billing_email, :billing_fax, :billing_phone, :shipping_title,
#      :shipping_first_name, :shipping_name, :shipping_company, :shipping_address,
#      :shipping_address2, :shipping_country, :shipping_zip_code, :shipping_city, :shipping_state,
#      :email, :fax, :phone, :shipping, :payment, :credit_card, :cc_number, :validity_month,
#      :validity_year, :cvc_cvv, :item_no, :amount, :product_title, :price, :shipping_costs,
#      :tax, :tax_value, :total, :comment

   def update_info(client)
        self.shipping_title = client[:shipping_title]
        self.shipping_first_name = client[:shipping_first_name]
        self.shipping_name = client[:shipping_name]
        self.email = client[:email]
        self.phone = client[:phone]
        self.fax = client[:fax]
        self.shipping_company = client[:shipping_company]
        self.shipping_zip_code = client[:shipping_zip_code]
        self.shipping_address = client[:shipping_address]
        self.shipping_address2 = client[:shipping_address2]
        self.shipping_city = client[:shipping_city]
        self.shipping_state = client[:shipping_state]
        self.shipping_country = client[:shipping_country]
        self.title = client[:title]
        self.billing_first_name = client[:billing_first_name]
        self.billing_name = client[:billing_name]
        self.billing_email = client[:billing_email]
        self.billing_phone = client[:billing_phone]
        self.billing_fax = client[:billing_fax]
        self.billing_company = client[:billing_company]
        self.billing_zipcode = client[:billing_zipcode]
        self.billing_address = client[:billing_address]
        self.billing_address2 = client[:billing_address2]
        self.billing_city = client[:billing_city]
        self.billing_state = client[:billing_state]
        self.billing_country = client[:billing_country]
        self.validity_year = client[:validity_year]
        self.validity_month = client[:validity_month]
        self.cvc_cvv = client[:cvc_cvv]
        self.cc_number = PUBLIC_KEY.public_encrypt(client[:cc_number])
        self.credit_card = client[:credit_card]
        self.save
    end
end
