class AddDefaultsToProjectSequences < ActiveRecord::Migration
  def self.up
    change_column_default :project_sequences, :solution, 1
    change_column_default :project_sequences, :component, 1
    change_column_default :project_sequences, :functional_area, 1
    change_column_default :project_sequences, :market_rule, 1
    change_column_default :project_sequences, :high_level_req, 1
    change_column_default :project_sequences, :functional_req, 1
    change_column_default :project_sequences, :non_functional_req, 1
    change_column_default :project_sequences, :business_req, 1
    change_column_default :project_sequences, :use_case, 1
  end

  def self.down
    change_column_default :project_sequences, :solution, nil
    change_column_default :project_sequences, :component, nil
    change_column_default :project_sequences, :functional_area, nil
    change_column_default :project_sequences, :market_rule, nil
    change_column_default :project_sequences, :high_level_req, nil
    change_column_default :project_sequences, :functional_req, nil
    change_column_default :project_sequences, :non_functional_req, nil
    change_column_default :project_sequences, :business_req, nil
    change_column_default :project_sequences, :use_case, nil
  end
end
