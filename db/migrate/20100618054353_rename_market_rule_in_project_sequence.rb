class RenameMarketRuleInProjectSequence < ActiveRecord::Migration
  def self.up
    rename_column(:project_sequences, :market_rule, :rule)
  end

  def self.down
    rename_column(:project_sequences, :rule, :market_rule)
  end
end
