class CreateUseCaseStatuses < ActiveRecord::Migration
  def self.up
    create_table :use_case_statuses do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :use_case_statuses
  end
end
