class AddAccountIdToUseCaseStatuses < ActiveRecord::Migration
  def self.up
    add_column :use_case_statuses, :account_id, :integer
  end

  def self.down
    remove_column :use_case_statuses, :account_id
  end
end
