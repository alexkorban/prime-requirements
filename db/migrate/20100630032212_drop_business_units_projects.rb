class DropBusinessUnitsProjects < ActiveRecord::Migration
  def self.up
    drop_table :business_units_projects
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
