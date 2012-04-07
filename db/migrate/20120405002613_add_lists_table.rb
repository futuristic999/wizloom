class AddListsTable < ActiveRecord::Migration
  def change
    create_table :lists do |t|
       t.integer :id
       t.string  :list_type
       t.string  :item_class
       t.string  :item_type_id
       t.string  :filter
       t.string  :order_by
    end


  end

  def down
  end
end
