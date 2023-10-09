class CreateFunctionalReqs < ActiveRecord::Migration
  def self.up
    create_table :functional_reqs do |t|
      t.string :name
      t.string :description
      t.string :seq
      t.integer :project_id, :limit => 8
      t.timestamps
    end

  end

  def self.down
    drop_table :functional_reqs
  end
end
