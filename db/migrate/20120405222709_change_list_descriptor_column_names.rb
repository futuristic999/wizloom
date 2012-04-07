class ChangeListDescriptorColumnNames < ActiveRecord::Migration
  def change
    add_column :list_descriptors, :associated_entry_id, :integer
  end

  def down
  end
end
