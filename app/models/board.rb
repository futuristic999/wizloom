class Board < ActiveRecord::Base
    has_and_belongs_to_many :blocks, :join_table => 'board_blocks'
end
