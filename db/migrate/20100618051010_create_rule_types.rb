class CreateRuleTypes < ActiveRecord::Migration
  def self.up
    create_table :rule_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :rule_types
  end
end
