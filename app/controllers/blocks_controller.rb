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
    if viewType=='new'
        isPrimaryBlock = true
    else
        isPrimaryBlock = false
    end

    block = Block.new(attributes={
            :entry_type=>params[:block][:entry_type], 
            :view_type=>params[:view_type],
            :template_id => params[:template_id],
            :name => "#{template.name}_#{params[:view_type]}",
            :is_primary_block => isPrimaryBlock,
            :associated_entry_id => params[:associated_entry_id]
            })
    block.save    
  end

  def save
  end

  def handle
    puts "params = #{params}" 
    action = params[:action]
    blockId = params[:block_id]
  
    instruction  = params[:instruction]
    mode = ''
    data = Hash.new

    @block = Block.find(blockId)

    if instruction == 'save'
        puts 'instruction is save.' 
        @entry = saveEntry(params)
        @template = @block.template
        mode = 'display'
        data[:entry] = @entry

        
            if @block.view_type == 'main'
                entryTemplate = "entries/table_format.html.erb"
                entryHtml = render_to_string(:template=>entryTemplate, :layout=>false)
                params[:main_entry_id] = @entry.id
                params[:mode] = 'display'
                blockHtml = getBlockHtml(@block.id, params)
                render :json => {
                    :entry_html=>entryHtml,
                    :block => @block,
                    :block_html=>blockHtml,
                    :entry_id=>@entry.id
                }
            end

            if @block.view_type == 'association_list' 
              @entries = getAssociatedEntries(params[:main_entry_id], @block.template.id)
              #blockTemplate = "blocks/configured/#{@block.entry_type}_#{@block.view_type}.html.erb"
              params[:entries] = @entries 
              blockHtml = getBlockHtml(@block.id, params)
              render :json => {
                :block_html => blockHtml,
                :block => @block
              }
              
           end
    end


    if instruction == 'new'
        puts 'instruction is new'
        params = Hash.new
        params[:saveUrl] = "/blocks/handle?instruction=save&block_id=#{blockId}"
        templateHtml = getTemplateHtml(@block.template.id, params)

        if request.xhr?
            render :json => {
                :template_html => templateHtml
    
            }
        end

    end


  end




  def get
    blockId = params[:id]
    @block = Block.find(blockId)
    
    blockHtml = getBlockHtml(blockId, params) 
    @saveUrl = "/blocks/handle?instruction=save&block_id=#{@block.id}&template_id=#{@block.template.id}" 
    @saveButtonClass = "block_save_main_entry"

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
