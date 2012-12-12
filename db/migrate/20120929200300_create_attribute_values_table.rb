class CreateAttributeValuesTable < ActiveRecord::Migration
  def up
    create_table :attribute_values do |t|
        t.integer :entry_id
        t.integer :attribute_id
        t.string  :value
        t.string  :value_type
    end

  end

  def down
  end
end
