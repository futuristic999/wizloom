class ChangeAttributesTableToAttrs < ActiveRecord::Migration
  def change
    drop_table :attributes
    create_table :attrs do |t|
        t.integer :entity_id
        t.string  :name
        t.string  :label
        t.string  :default_value
        t.string  :options
        t.string  :unit
    end
  end

  def down
  end
end
