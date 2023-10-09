class CreateBusinessReqsUseCases < ActiveRecord::Migration
  def self.up
    create_table :business_reqs_use_cases do |t|
      t.integer :business_req_id, :limit => 8
      t.integer :use_case_id, :limit => 8
    end
  end

  def self.down
    drop_table :business_reqs_use_cases
  end
end
