class AddProjectIdToProjectSequences < ActiveRecord::Migration
  def self.up
    add_column :project_sequences, :project_id, :integer, :limit => 8
  end

  def self.down
    remove_column :project_sequences, :project_id
  end
end
