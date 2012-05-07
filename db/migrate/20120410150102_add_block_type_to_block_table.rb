class AddBlockTypeToBlockTable < ActiveRecord::Migration
  def change
    add_column :blocks, :block_type, :string
  end
end
