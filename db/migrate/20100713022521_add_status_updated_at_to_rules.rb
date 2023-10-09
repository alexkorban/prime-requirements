class AddStatusUpdatedAtToRules < ActiveRecord::Migration
  def self.up
    add_column :rules, :status_updated_at, :datetime
  end

  def self.down
    remove_column :rules, :status_updated_at
  end
end
