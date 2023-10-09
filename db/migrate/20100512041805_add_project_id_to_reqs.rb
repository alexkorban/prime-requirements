class AddProjectIdToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :project_id, :integer, :limit => 8 
  end

  def self.down
    remove_column :reqs, :project_id
  end
end
