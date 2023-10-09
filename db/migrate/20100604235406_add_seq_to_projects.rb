class AddSeqToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :seq, :string
  end

  def self.down
    remove_column :projects, :seq
  end
end
