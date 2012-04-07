class ChangeListItemIdToString < ActiveRecord::Migration
  def change
     remove_column :templates, :list_item_id
     add_column :templates, :list_item_descriptor, :string
  end

  def down
  end
end
