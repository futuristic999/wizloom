class AddFieldIdToSpecialFields < ActiveRecord::Migration
  def change
     add_column :urls, :field_id, :integer
     add_column :tasks, :field_id, :integer
     add_column :locations, :field_id, :integer
     add_column :comments, :field_id, :integer
  end
end
