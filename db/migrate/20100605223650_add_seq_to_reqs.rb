class AddSeqToReqs < ActiveRecord::Migration
  def self.up
    add_column :reqs, :seq, :string
  end

  def self.down
    remove_column :reqs, :seq
  end
end
