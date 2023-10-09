class AddDefaultsToAccountSequences < ActiveRecord::Migration
  def self.up
    change_column_default(:account_sequences, :project, 1)
  end

  def self.down
    change_column_default(:account_sequences, :project, nil)
  end
end
