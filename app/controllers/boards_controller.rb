class BoardsController < ApplicationController

  def new
    @blocks = Block.all
  end
  
  def list
  end

  def create
  end

  def save
  end

  def delete
  end

  def get
    boardId = params[:id]
    if params.has_key?(:mode)
        @mode = params[:mode]
    else
        @mode = 'new'
    end

    @board = Board.includes(:blocks).find(boardId)
    if @mode == 'display' || @mode == 'edit'
        @mainEntryId = params[:main_entry_id]
    else 
        @mainEntryId = 0
    end

    @mainBlockId = 0
    @blockIds = ""
    @board.blocks.each do |block|
        @blockIds += ",#{block.id}"
        blockHtml = getBlockHtml(block.id, params)
        block['blockHtml'] = blockHtml
        if block.view_type == 'main'
            @mainBlockId = block.id
        end
    end
  end

end
