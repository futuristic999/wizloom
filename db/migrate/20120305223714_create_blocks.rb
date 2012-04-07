class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :entry_type
      t.string :view_type
      t.string :filter
      t.string :order

      t.timestamps
    end
  end
end
