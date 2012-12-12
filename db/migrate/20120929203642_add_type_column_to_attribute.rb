class AddTypeColumnToAttribute < ActiveRecord::Migration
  def change
    add_column :attributes, :attr_type, :string
  end
end
