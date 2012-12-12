class RenameAttributeValueTable < ActiveRecord::Migration
  def change
    drop_table :attribute_values

    create_table :attr_values do |t|
        t.integer :entry_id
        t.integer :attr_id
        t.string  :value
        t.string  :value_type
    end

  end

  def down
  end
end
