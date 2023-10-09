class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
