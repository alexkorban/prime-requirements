class AddStageIdToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :stage_id, :integer, :limit => 8
  end

  def self.down
    remove_column :components, :stage_id
  end
end
