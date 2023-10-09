class AddTypeToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :type, :string
  end

  def self.down
    remove_column :reqs, :type
  end
end
