class CreateWeightEntries < ActiveRecord::Migration
  def change
    create_table :weight_entries do |t|
      t.integer :weight
      t.string :unit
      t.text :note
      t.date :date

      t.timestamps
    end
  end
end
