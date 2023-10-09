class AddRuleIdToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :rule_id, :integer, :limit => 8
  end

  def self.down
    remove_column :reqs, :rule_id
  end
end
