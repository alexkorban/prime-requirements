class CreateReqs < ActiveRecord::Migration
  def self.up
    create_table :reqs do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reqs
  end
end
