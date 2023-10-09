class AddHighLevelReqIdToUseCases < ActiveRecord::Migration
  def self.upus
    add_column :use_cases, :high_level_req_id, :integer, :limit => 8
  end

  def self.down
    remove_column :use_cases, :high_level_req_id
  end
end
