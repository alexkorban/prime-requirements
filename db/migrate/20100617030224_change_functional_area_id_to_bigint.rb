class ChangeFunctionalAreaIdToBigint < ActiveRecord::Migration
  def self.up
    change_column(:functional_areas, :id, :integer, :limit => 8)
  end

  def self.down
    change_column(:functional_areas, :id, :integer)
  end
end

