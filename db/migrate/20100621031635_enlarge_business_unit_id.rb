class EnlargeBusinessUnitId < ActiveRecord::Migration
  def self.up
    change_column(:business_units, :id, :integer, :limit => 8)
  end

  def self.down
    change_column(:business_units, :id, :integer)
  end
end
