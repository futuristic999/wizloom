class AddFieldIdToFieldValue < ActiveRecord::Migration
  def change
    add_column :field_values, :field_id, :integer
  end
end
