class AddStatusUpdatedAtToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :status_updated_at, :datetime
  end

  def self.down
    remove_column :reqs, :status_updated_at
  end
end
