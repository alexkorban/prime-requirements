class AddStageToProjectSequences < ActiveRecord::Migration
  def self.up
    add_column :project_sequences, :stage, :integer, :default => 1
  end

  def self.down
    remove_column :project_sequences, :stage
  end
end
