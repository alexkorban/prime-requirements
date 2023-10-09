class RenameFunctionalAreaIdToComponentIdInUseCases < ActiveRecord::Migration
  def self.up
    rename_column :use_cases, :functional_area_id, :component_id
  end

  def self.down
    rename_column :use_cases, :component_id, :functional_area_id
  end
end
