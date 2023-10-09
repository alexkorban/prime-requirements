class CreateProjectSequences < ActiveRecord::Migration
  def self.up
    create_table :project_sequences do |t|
      t.integer :solution
      t.integer :component
      t.integer :functional_area
      t.integer :market_rule
      t.integer :high_level_req
      t.integer :functional_req
      t.integer :non_functional_req
      t.integer :business_req
      t.integer :use_case
    end
  end

  def self.down
    drop_table :project_sequences
  end
end
