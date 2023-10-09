class MakeIdFieldsBigger < ActiveRecord::Migration
  def self.up
    change_column(:projects, :id, :integer, :limit => 8)
    change_column(:reqs, :id, :integer, :limit => 8)
  end

  def self.down
    change_column(:projects, :id, :integer)
    change_column(:reqs, :id, :integer)
  end
end
