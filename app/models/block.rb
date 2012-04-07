class Block < ActiveRecord::Base
    has_and_belongs_to_many :boards, :join_table => "board_blocks"
    belongs_to :template
end
