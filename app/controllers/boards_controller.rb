class BoardsController < ApplicationController

  def new
    @blocks = Block.all
  end


  def index
    render :template=>'/boards/index.html.erb'
  end
  
  def list
    render :template=>'/boards/index.html.erb'
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
        puts "board.blocks=#{@board.blocks}"
        @blockIds += ",#{block.id}"
        params[:block_id] = block.id
        blockHtml = getBlockHtml(params)
        block['blockHtml'] = blockHtml
        if block.view_type == 'main'
            @mainBlockId = block.id
        end
    end

    template = "/boards/board_#{@board.display}_format.html.erb"

    render :template => template
  end

  def journal 
    render :template => "/boards/board_journal.html.erb" 

  end

  def default
    
    @board = Board.find(10)
    topic = Topic.find(1)
    #childTopicAssociations = topic.topic_associations.where(:association_type=>'child')
   
    jobBlock = {:name=>'Jobs', :entry_type=>'topic', :template_id=>77, :topic_id=>2, :view_type=>'list_full'}
    companyBlock = {:name=>'Companies', :entry_type=>'topic', :template_id=>76, :topic_id=>3, :view_type => 'list_full'}
    questionBlock = {:name=>'Questions', :entry_type=>'topic', :template_id=>80, :topic_id=>4, :view_type => 'list_full'}
    algorithmBlock = {:name=>'Algorithms', :entry_type=>'topic', :template_id=>87, :topic_id=>5, :view_type => 'list_full'}
    tasksBlock = {:name=>'Tasks', :entry_type=>'topic', :template_id=>85, :topic_id=>1, :view_type=>'list_full'}

    dashboardBlock = {:name=>'Career', :entry_type=>'topic', :mainBlock=> true, :include_topics=> [1,2,3,4,5], :view_type=>'dashboard'}
    journalBlock = {:name=>'Journal', :entry_type=>'topic', :mainBlock=>true, :include_topics=>[1,2,3,4,5], :view_type=>'journal'}

    topic_ids = dashboardBlock[:include_topics]
    topics = Topic.find(topic_ids)
    topicMap = Hash.new
    topics.each do |topic|
        topicMap[topic.id] = topic
    end

    dashboardBlock[:topic_map] = topicMap
    journalBlock[:topic_map] = topicMap

    @board.config = {
        :tabs => {
            'Dashboard' => dashboardBlock,
            'Jobs' => jobBlock,
            'Company' => companyBlock,
            'Question' => questionBlock,
            'Algorithm' => algorithmBlock,
            'Tasks' => tasksBlock,
            'Journal' => journalBlock
        },

        :default_tab => 'dashboard'
    }
    
    #@boardEntries = getBoardEntries(@board) 
    #@boardEntries = getBoardEntries(@board)
    #@config = getConfig(@board)
    
    @config = @board.config

    render :template => "/boards/board_default.html.erb"

  end

  def tabbed 
    render :template => "/boards/board_tabbed.html.erb"
  end

  def getConfig(board)
    config = Hash.new
    if board.config != nil 
        config = ActiveSupport::JSON.decode(board.config)
    end
    return config
  end



  def getBoardEntries(board)
    boardEntries = Hash.new
    topic = board.topic
    childTopicAssociations = topic.topic_associations.where(:association_type=>'child')

    childTopicAssociations.each do |topicAssociation|
        
        entries = Entry.where(:template_id => topicAssociation.associated_topic.template_id)
        boardEntries[topicAssociation.associated_topic.id] = entries
    end
    return boardEntries
  end




  def getBoardEntities(board)
    topic = board.topic

  end
end
