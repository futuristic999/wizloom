class AddTopicIdsToEntriesTable < ActiveRecord::Migration

  def change
    add_column :entries, :topic_ids,:string
  end


end
