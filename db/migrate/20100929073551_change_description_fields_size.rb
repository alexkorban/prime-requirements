class ChangeDescriptionFieldsSize < ActiveRecord::Migration
  TABLES = [:components, :functional_areas, :functional_reqs, :high_level_reqs, :non_functional_reqs, :projects, :rules,
     :solutions, :stages, :teams, :use_cases]
  def self.up
    TABLES.each { |t| change_column(t, :description, :text)}
  end

  def self.down
    TABLES.each { |t| change_column(t, :description, :string)}
  end
end
