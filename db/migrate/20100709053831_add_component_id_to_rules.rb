class AddComponentIdToRules < ActiveRecord::Migration
  def self.up
    add_column :rules, :component_id, :integer, :limit => 8
  end

  def self.down
    remove_column :rules, :component_id
  end
end
