class AddAccountIdToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :account_id, :integer
  end

  def self.down
    remove_column :statuses, :account_id
  end
end
