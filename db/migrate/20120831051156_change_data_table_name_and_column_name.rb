class ChangeDataTableNameAndColumnName < ActiveRecord::Migration
  def up
  
      rename_table :data, :data_keys
      remove_column :data_keys, :type
      add_column :data_keys, :data_type, :string
  end

  def down
  end
end
