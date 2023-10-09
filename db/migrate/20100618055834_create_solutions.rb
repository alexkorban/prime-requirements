class CreateSolutions < ActiveRecord::Migration
  def self.up
    create_table :solutions do |t|
      t.string :name
      t.string :description
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :solutions
  end
end
