class AddAutoListIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :auto_list_id, :integer
  end
end
