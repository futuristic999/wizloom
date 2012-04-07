class AddNewToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :name, :string
  end
end
