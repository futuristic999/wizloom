class AddEntityIdColumneToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entity_id, :integer
  end
end
