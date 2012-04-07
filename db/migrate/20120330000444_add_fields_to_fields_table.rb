class AddFieldsToFieldsTable < ActiveRecord::Migration
  def change
    add_column :fields, :list_item_type, :string
    add_column :fields, :list_item_id, :integer
  end
end
