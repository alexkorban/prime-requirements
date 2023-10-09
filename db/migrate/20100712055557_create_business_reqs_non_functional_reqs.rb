class CreateBusinessReqsNonFunctionalReqs < ActiveRecord::Migration
  def self.up
    create_table(:business_reqs_non_functional_reqs, :id => false) do |t|
      t.integer :business_req_id, :limit => 8
      t.integer :non_functional_req_id, :limit => 8
    end
  end

  def self.down
    drop_table :business_reqs_non_functional_reqs
  end
end
 