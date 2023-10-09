class CreateHighLevelReqs < ActiveRecord::Migration
  def self.up
    create_table :high_level_reqs do |t|
      t.string :name
      t.string :description
      t.string :seq
      t.integer :project_id, :limit => 8
      t.integer :component_id, :limit => 8
      t.integer :rule_id, :limit => 8
      t.timestamps
    end

  end

  def self.down
    drop_table :high_level_reqs
  end
end
