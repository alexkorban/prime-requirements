class CreateRuleStatuses < ActiveRecord::Migration
  def self.up
    create_table :rule_statuses do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :rule_statuses
  end
end
