class AddEntryTypeToEntriesTable < ActiveRecord::Migration
  def change
    add_column :entries, :entry_type, :string
  end
end
