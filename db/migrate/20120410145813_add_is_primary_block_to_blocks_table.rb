class AddIsPrimaryBlockToBlocksTable < ActiveRecord::Migration
  def change
    add_column :blocks, :is_primary_block, :boolean
  end
end
