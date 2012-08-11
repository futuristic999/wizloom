class Board < ActiveRecord::Base

    has_many  :board_blocks,
              :foreign_key => "board_id",
              :class_name => "BoardBlock",
              :order=>'display_order ASC'

    has_many :blocks, 
              :through => :board_blocks, 
              :order=>'display_order ASC'
    belongs_to :topic, 
               :class_name => "Topic"
end
