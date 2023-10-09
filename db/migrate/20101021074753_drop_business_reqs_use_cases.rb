class DropBusinessReqsUseCases < ActiveRecord::Migration
  def self.up
    drop_table :business_reqs_use_cases
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
