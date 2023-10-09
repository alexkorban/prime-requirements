class DropReqs < ActiveRecord::Migration
  def self.up
    drop_table :reqs
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
