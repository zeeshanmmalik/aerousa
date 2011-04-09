class CreateAsLoggers < ActiveRecord::Migration
  def self.up
    create_table :as_loggers do |t|
      t.integer :order_no
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :as_loggers
  end
end
