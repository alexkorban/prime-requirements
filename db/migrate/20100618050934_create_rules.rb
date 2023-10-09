class CreateRules < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.string :name
      t.string :description
      t.string :seq
      t.integer :rule_type_id
      t.integer :rule_status_id
      t.integer :project_id, :limit => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :rules
  end
end
