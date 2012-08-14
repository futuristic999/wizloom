class AddTopicEntriesTable < ActiveRecord::Migration
  def change
    create_table :topic_entries do |t|
      t.integer :topic_id
      t.integer :entry_id
      t.integer :display_order
    end
  end

  def down
  end
end
