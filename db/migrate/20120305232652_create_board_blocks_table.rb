class CreateBoardBlocksTable < ActiveRecord::Migration

  def change
    create_table :board_blocks, :id => false do |t|
      t.integer :board_id
      t.integer :block_id
      t.integer :display_order
    end
  end

end
