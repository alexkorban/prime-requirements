class AddUseCaseIdToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :use_case_id, :integer, :limit => 8
  end

  def self.down
    remove_column :reqs, :use_case_id
  end
end
