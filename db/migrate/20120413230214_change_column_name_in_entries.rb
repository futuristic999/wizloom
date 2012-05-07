class ChangeColumnNameInEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :descritpor
    add_column :entries, :descriptor, :string
  end

  def down
  end
end
