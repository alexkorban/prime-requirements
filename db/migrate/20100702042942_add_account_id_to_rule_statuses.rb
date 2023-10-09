class AddAccountIdToRuleStatuses < ActiveRecord::Migration
  def self.up
    add_column :rule_statuses, :account_id, :integer
  end

  def self.down
    remove_column :rule_statuses, :account_id
  end
end
