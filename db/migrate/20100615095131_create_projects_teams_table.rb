class CreateProjectsTeamsTable < ActiveRecord::Migration
  def self.up
    create_table :projects_teams do |t|
      t.integer :project_id, :limit => 8
      t.integer :team_id
    end

  end

  def self.down
    drop_table :projects_teams
  end
end
