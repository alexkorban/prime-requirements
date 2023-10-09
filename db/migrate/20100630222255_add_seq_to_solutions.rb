class AddSeqToSolutions < ActiveRecord::Migration
  def self.up
    add_column :solutions, :seq, :string
  end

  def self.down
    remove_column :solutions, :seq
  end
end
