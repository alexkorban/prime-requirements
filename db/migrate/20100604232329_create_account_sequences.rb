class CreateAccountSequences < ActiveRecord::Migration
  def self.up
    create_table :account_sequences do |t|
      t.integer :account_id, :limit => 8
      t.integer :project
    end
  end

  def self.down
    drop_table :account_sequences
  end
end
