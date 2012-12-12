class AddEntryPropertiesTable < ActiveRecord::Migration
  def up
    drop_table :entry_properties
    create_table :entry_properties do |t|
        t.integer :entry_id
        t.integer :property_id
        t.string  :property_name
        t.string  :property_value
    end
  end

  def down
  end
end
