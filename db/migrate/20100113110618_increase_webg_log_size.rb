class IncreaseWebgLogSize < ActiveRecord::Migration
  def self.up
      change_column :clients, :webg_log, :text
  end

  def self.down
      change_column :clients, :webg_log, :string
  end
end
