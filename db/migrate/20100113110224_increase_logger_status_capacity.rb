class IncreaseLoggerStatusCapacity < ActiveRecord::Migration
  def self.up
      change_column :as_loggers, :status, :text
      change_column :as_loggers, :order_no, :string
  end

  def self.down
      change_column :as_loggers, :status, :string
      change_column :as_loggers, :order_no, :int
  end
end
