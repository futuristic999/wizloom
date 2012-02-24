class AddColumnsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :template_id, :integer
    add_column :fields, :style, :string
    add_column :fields, :display_order, :integer
  end
end
