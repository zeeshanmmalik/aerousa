class CreateLoginLogs < ActiveRecord::Migration
  def self.up
    create_table :login_logs do |t|
      t.string :username
      t.string :status
      t.string :ip
      t.timestamps
    end
  end

  def self.down
    drop_table :login_logs
  end
end
