class ConvertCcNumberToBinary < ActiveRecord::Migration
  def self.up
      change_column :clients, :cc_number, :binary
  end

  def self.down
      raise ActiveRecord::IrreversibleMigration, "Can't change back cc_number"
  end
end
