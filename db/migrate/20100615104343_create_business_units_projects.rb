class CreateBusinessUnitsProjects < ActiveRecord::Migration
  def self.up
    create_table :business_units_projects do |t|
      t.integer :project_id, :limit => 8
      t.integer :business_unit_id
    end

  end

  def self.down
    drop_table :business_units_projects
  end
end
