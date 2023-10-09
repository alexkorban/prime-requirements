class AddStatusIdToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :status_id, :integer
  end

  def self.down
    remove_column :reqs, :status_id
  end
end
