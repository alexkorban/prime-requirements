class AddStatusToNonFunctionalReqs < ActiveRecord::Migration
  def self.up
    add_column :non_functional_reqs, :status_id, :integer
    add_column :non_functional_reqs, :status_updated_at, :datetime
  end

  def self.down
    remove_column :non_functional_reqs, :status_updated_at
    remove_column :non_functional_reqs, :status_id
  end
end
