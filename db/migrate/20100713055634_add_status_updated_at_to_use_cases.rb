class AddStatusUpdatedAtToUseCases < ActiveRecord::Migration
  def self.up
    add_column :use_cases, :status_updated_at, :datetime
  end

  def self.down
    remove_column :use_cases, :status_updated_at
  end
end
