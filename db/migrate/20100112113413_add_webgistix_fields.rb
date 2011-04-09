class AddWebgistixFields < ActiveRecord::Migration
  def self.up
    add_column :clients, :webg_result, :string
    add_column :clients, :webg_order_code, :string
    add_column :clients, :webg_log, :string
    add_column :clients, :webg_error, :boolean
    add_column :clients, :tracking_no, :string
    add_column :clients, :ship_date, :string
  end

  def self.down
    remove_column :clients, :webg_result
    remove_column :clients, :webg_order_code
    remove_column :clients, :webg_log
    remove_column :clients, :webg_error
    remove_column :clients, :tracking_no
    remove_column :clients, :ship_date
  end
end
