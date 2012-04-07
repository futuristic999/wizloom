class AddAssociatedEntryIdToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :associated_entry_id, :integer
  end
end
