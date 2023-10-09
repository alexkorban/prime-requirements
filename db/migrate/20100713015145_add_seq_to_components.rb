class AddSeqToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :seq, :string
  end

  def self.down
    remove_column :components, :seq
  end
end
