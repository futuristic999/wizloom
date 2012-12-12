class AddValueTypeToAttrTable < ActiveRecord::Migration
  def change
    add_column :attrs, :value_type, :string
    add_column :attrs, :display_order, :integer
  end
end
