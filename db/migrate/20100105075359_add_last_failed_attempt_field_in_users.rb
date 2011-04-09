class AddLastFailedAttemptFieldInUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_failed_attempt, :datetime
  end

  def self.down
    remove_column :users, :last_failed_attempt
  end
end
