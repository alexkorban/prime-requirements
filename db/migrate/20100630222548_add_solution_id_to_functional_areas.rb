class AddSolutionIdToFunctionalAreas < ActiveRecord::Migration
  def self.up
    add_column :functional_areas, :solution_id, :integer
  end

  def self.down
    remove_column :functional_areas, :solution_id
  end
end
