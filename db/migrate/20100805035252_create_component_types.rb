class CreateComponentTypes < ActiveRecord::Migration
  def self.up
    create_table :component_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :component_types
  end
end
