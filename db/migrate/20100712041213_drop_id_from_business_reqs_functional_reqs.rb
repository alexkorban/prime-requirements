class DropIdFromBusinessReqsFunctionalReqs < ActiveRecord::Migration
  def self.up
    remove_column :business_reqs_functional_reqs, :id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
