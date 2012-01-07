class AddDateToWeightEntries < ActiveRecord::Migration
  def change
    add_column :weight_entries, :date, :date
  end
end
