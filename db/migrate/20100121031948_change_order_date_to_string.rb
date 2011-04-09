class ChangeOrderDateToString < ActiveRecord::Migration
  def self.up
  	change_column :clients, :order_date, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't change order_date back from string to date"
  end
end
