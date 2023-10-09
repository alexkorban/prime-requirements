class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :account_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
