class CreateUseCases < ActiveRecord::Migration
  def self.up
    create_table :use_cases do |t|
      t.integer :project_id, :limit => 8
      t.string :name
      t.string :description
      t.string :seq
      t.integer :functional_area_id, :limit => 8
      t.integer :use_case_status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :use_cases
  end
end
