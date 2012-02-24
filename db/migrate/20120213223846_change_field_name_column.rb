class ChangeFieldNameColumn < ActiveRecord::Migration
  def change
    add_column :fields, :fieldname, :string
    remove_column :fields, :name
  end
end
