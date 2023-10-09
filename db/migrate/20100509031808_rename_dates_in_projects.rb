class RenameDatesInProjects < ActiveRecord::Migration
  def self.up
    rename_column :projects, :starts_on, :start_on
    rename_column :projects, :ends_on, :finish_on
  end

  def self.down
    rename_column :projects, :start_on, :starts_on
    rename_column :projects, :finish_on, :ends_on
  end
end
