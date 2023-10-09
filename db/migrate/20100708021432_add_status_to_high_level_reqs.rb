class AddStatusToHighLevelReqs < ActiveRecord::Migration
  def self.up
    add_column :high_level_reqs, :status_id, :integer
    add_column :high_level_reqs, :status_updated_at, :datetime
  end

  def self.down
    remove_column :high_level_reqs, :status_updated_at
    remove_column :high_level_reqs, :status_id
  end
end
