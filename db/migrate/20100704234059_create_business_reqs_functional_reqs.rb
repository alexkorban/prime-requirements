class CreateBusinessReqsFunctionalReqs < ActiveRecord::Migration
  def self.up
    create_table :business_reqs_functional_reqs do |t|
      t.integer :business_req_id, :limit => 8
      t.integer :functional_req_id, :limit => 8
    end
  end

  def self.down
    drop_table :business_reqs_functional_reqs
  end
end
