class BoardBlock < ActiveRecord::Base
    belongs_to :board, :foreign_key => "board_id", :class_name => "Board"
    belongs_to :block, :foreign_key => "block_id", :class_name => "Block"
end
