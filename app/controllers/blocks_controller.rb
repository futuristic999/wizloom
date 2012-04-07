class BlocksController < ApplicationController
 
  helper_method :saveEntry
   
  def index
    
  end

  def list
    @blocks = Block.includes(:template).all
  end

  def new
    @block = Block.new
    @templates = Template.all
    @entries = Entry.all
  end

  def create
    puts "params = #{params}"
    template_id = params[:template_id]
    template = Template.find(template_id)
    viewType = params[:view_type]
    block = Block.new(attributes={
            :entry_type=>params[:block][:entry_type], 
            :view_type=>params[:view_type],
            :template_id => params[:template_id],
            :name => "#{template.name}_#{params[:view_type]}",
            :associated_entry_id => params[:associated_entry_id]
            })
    block.save    
  end

  def save
  end

  def handle
    puts "params = #{params}" 
    blockId = params[:id]
    instruction  = params[:instruction]
    mode = ''
    data = Hash.new

    block = Block.find(blockId)
    if instruction == 'add'
        puts 'action is add.' 
        @entry = saveEntry(params)
        if(block.associated_entry_id != nil) 
            addAssociatedEntry(block.associated_entry_id, @entry.id)
        end
        mode = 'display'
        data[:entry] = @entry
    end

    blockHtml = getBlockHtml(block.id, mode, data)
    puts "blockHtml=#{blockHtml}"

    if request.xhr? 
        render :json => {
            :blockHtml => blockHtml
        }
    end
  end

  def get
    blockId = params[:id]
    data = Hash.new
    blockHtml = getBlockHtml(blockId, 'editor', data)


    if request.xhr? 
        render :json => {
            :blockHtml => blockHtml
    } 

    else
        blockTemplate = "blocks/configured/#{@block.entry_type}_#{@block.view_type}.html.erb"
        render :template => blockTemplate
    end
  end

  def delete
    @blockId = params[:id]
    Block.delete(@blockId)
  end

end
