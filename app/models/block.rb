class Block < ActiveRecord::Base
    has_many :board_blocks, 
             :foreign_key => "block_id",
             :class_name=>"BoardBlock"

    belongs_to :template
end
