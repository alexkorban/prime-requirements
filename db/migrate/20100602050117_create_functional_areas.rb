class CreateFunctionalAreas < ActiveRecord::Migration
  def self.up
    create_table :functional_areas do |t|
      t.string :description
      t.string :notes
      t.integer :project_id, :limit => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :functional_areas
  end
end
