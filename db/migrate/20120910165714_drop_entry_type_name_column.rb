class DropEntryTypeNameColumn < ActiveRecord::Migration
  def change
    remove_column :entry_types, :type_name
  end

  def down
  end
end
