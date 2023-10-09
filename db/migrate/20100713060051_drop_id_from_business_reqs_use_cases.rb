class DropIdFromBusinessReqsUseCases < ActiveRecord::Migration
  def self.up
    remove_column :business_reqs_use_cases, :id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
