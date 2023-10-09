class RenameUseCaseStatusId < ActiveRecord::Migration
  def self.up
    rename_column :use_cases, :use_case_status_id, :status_id
  end

  def self.down
    rename_column :use_cases, :status_id, :use_case_status_id 
  end
end
