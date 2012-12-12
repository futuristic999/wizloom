class ChangeEntryTypeNameColumn < ActiveRecord::Migration
  def change
    remove_column :entry_types, :entry_name
    add_column :entry_types, :name, :string
  end

  def down
  end
end
