class DropAdminTable < ActiveRecord::Migration
  def self.up
    drop_table :admins
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
