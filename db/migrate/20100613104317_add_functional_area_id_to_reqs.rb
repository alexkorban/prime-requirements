class AddFunctionalAreaIdToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :functional_area_id, :integer, :limit => 8
  end

  def self.down
    remove_column :reqs, :functional_area_id
  end
end
