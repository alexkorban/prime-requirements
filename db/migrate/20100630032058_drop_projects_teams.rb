class DropProjectsTeams < ActiveRecord::Migration
  def self.up
    drop_table :projects_teams
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
