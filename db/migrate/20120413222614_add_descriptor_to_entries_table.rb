class AddDescriptorToEntriesTable < ActiveRecord::Migration
  def change
    add_column :entries, :descritpor, :string
  end
end
