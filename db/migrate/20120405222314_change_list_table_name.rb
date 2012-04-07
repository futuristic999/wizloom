class ChangeListTableName < ActiveRecord::Migration
  def change
    rename_table :lists, :list_descriptors
  end

  def down
  end
end
