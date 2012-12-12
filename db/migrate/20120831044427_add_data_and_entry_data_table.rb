class AddDataAndEntryDataTable < ActiveRecord::Migration
  def up
    create_table :data do |t|
        t.integer :id
        t.string  :key
        t.string  :type
        t.string  :default_value
        t.string  :options
    end

    create_table :entry_data do |t|
        t.integer :entry_id
        t.integer :data_id
        t.string  :data_key
        t.string  :data_value
        t.date    :journal_date
    end
  end

  def down
  end
end
