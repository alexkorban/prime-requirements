class AddSeqToFunctionalAreas < ActiveRecord::Migration
  def self.up
    add_column :functional_areas, :seq, :string
  end

  def self.down
    remove_column :functional_areas, :seq
  end
end
