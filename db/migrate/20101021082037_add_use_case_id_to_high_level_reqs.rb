class AddUseCaseIdToHighLevelReqs < ActiveRecord::Migration
  def self.up
    add_column :high_level_reqs, :use_case_id, :integer, :limit => 8
  end

  def self.down
    remove_column :high_level_reqs, :use_case_id
  end
end
