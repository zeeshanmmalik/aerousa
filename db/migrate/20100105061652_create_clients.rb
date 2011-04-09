class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      
      t.string :order_no
      t.date :order_date
      t.string :customer_no
      t.string :title
      t.string :billing_first_name
      t.string :billing_name
      t.string :billing_company
      t.string :billing_address
      t.string :billing_address2
      t.string :billing_country
      t.string :billing_zipcode
      t.string :billing_city
      t.string :billing_state
      t.string :billing_email
      t.string :billing_fax
      t.string :billing_phone
      t.string :shipping_title
      t.string :shipping_first_name
      t.string :shipping_name
      t.string :shipping_company
      t.string :shipping_address
      t.string :shipping_address2
      t.string :shipping_country
      t.string :shipping_zip_code
      t.string :shipping_city
      t.string :shipping_state
      t.string :email
      t.string :fax
      t.string :phone
      t.string :shipping
      t.string :payment
      t.string :credit_card
      t.string :cc_number
      t.string :validity_month
      t.string :validity_year
      t.string :cvc_cvv
      t.string :item_no
      t.string :amount
      t.string :product_title
      t.string :price
      t.string :shipping_costs
      t.string :tax
      t.string :tax_value
      t.string :total
      t.string :comment
      t.string :status_code
      t.string :status
      t.string :cc_result
      t.string :cc_code
      t.text :cc_log
      t.string :email_code
      t.integer :attempt_count, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
