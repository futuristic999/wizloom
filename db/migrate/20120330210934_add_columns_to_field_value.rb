class AddColumnsToFieldValue < ActiveRecord::Migration
  def change
    add_column :field_values, :list_descriptor, :string
    add_column :field_values, :list_display_order, :integer
  end
end
