class AddComponentTypeIdToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :component_type_id, :int
  end

  def self.down
    remove_column :components, :component_type_id
  end
end
