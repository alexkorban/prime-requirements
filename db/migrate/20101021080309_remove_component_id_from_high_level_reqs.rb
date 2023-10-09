class RemoveComponentIdFromHighLevelReqs < ActiveRecord::Migration
  def self.up
    remove_column :high_level_reqs, :component_id
  end

  def self.down
    add_column :high_level_reqs, :component_id, :integer, :limit => 8
  end
end
