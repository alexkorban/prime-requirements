class RenameAccountIdInTeams < ActiveRecord::Migration
  def self.up
    rename_column(:teams, :account_id, :business_unit_id)
  end

  def self.down
    rename_column(:teams, :business_unit_id, :account_id)
  end
end
