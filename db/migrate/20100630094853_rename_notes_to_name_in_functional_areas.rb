class RenameNotesToNameInFunctionalAreas < ActiveRecord::Migration
  def self.up
    rename_column :functional_areas, :notes, :name
  end

  def self.down
    rename_column :functional_areas, :name, :notes
  end
end
