class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.references :entry
      t.string :label
      t.string :value

      t.timestamps
    end
    add_index :field_values, :entry_id
  end
end
