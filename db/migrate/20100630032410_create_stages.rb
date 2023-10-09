class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.string :name
      t.string :description
      t.integer :project_id, :limit => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
