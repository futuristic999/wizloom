class AddListDescriptorColumnToFieldsTable < ActiveRecord::Migration
  def change
    add_column :fields, :list_descriptor_id, :integer
  end
end
