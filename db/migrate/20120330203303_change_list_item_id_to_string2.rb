class ChangeListItemIdToString2 < ActiveRecord::Migration
  def change
     #remove_column :templates, :list_item_id
     remove_column :templates, :list_item_descriptor
     remove_column :fields, :list_item_id
     add_column :fields, :list_item_descriptor, :string
  end


  def up
  end

  def down
  end
end
