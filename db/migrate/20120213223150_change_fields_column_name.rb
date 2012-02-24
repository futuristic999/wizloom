class ChangeFieldsColumnName < ActiveRecord::Migration
  def change
    add_column :fields, :fieldtype, :string
    remove_column :fields, :type
  end

  def up
  end

  def down
  end
end
