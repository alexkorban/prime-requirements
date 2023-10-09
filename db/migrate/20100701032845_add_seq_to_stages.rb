class AddSeqToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :seq, :string
  end

  def self.down
    remove_column :stages, :seq
  end
end
