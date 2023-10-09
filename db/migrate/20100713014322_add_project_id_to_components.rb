class AddProjectIdToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :project_id, :integer, :limit => 8
  end

  def self.down
    remove_column :components, :project_id
  end
end
