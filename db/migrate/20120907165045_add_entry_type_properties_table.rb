class AddEntryTypePropertiesTable < ActiveRecord::Migration
  def up
    create_table :entry_type_properties do |t|
        t.integer :entry_type_id
        t.string  :name
        t.string  :default_value
        t.string  :options
        t.string  :data_type
        t.string  :unit
        t.string  :key
    end
  end

  def down
  end
end
