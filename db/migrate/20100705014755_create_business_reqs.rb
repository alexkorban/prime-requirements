class CreateBusinessReqs < ActiveRecord::Migration
  def self.up
    create_table :business_reqs do |t|
      t.string :name
      t.string :description
      t.string :seq
      t.integer :project_id, :limit => 8
      t.integer :high_level_req_id, :limit => 8
      t.integer :rule_id, :limit => 8
      t.timestamps
    end

  end

  def self.down
    drop_table :business_reqs
  end
end
