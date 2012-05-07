class DropAndAddBoardBlockTable < ActiveRecord::Migration
  def change
     drop_table :board_blocks
     create_table :board_blocks do |t|
        t.integer :board_id
        t.integer :block_id
        t.integer :display_order
     end
  end

  def down
  end
end
