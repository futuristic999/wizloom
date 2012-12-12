class AddDisplayOrderColumnToAttributes < ActiveRecord::Migration
  def change
    add_column :attributes, :display_order, :integer
  end
end
