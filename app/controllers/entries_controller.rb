class EntriesController < ApplicationController


  def index
    @templates = Template.all()
    render :template => "/entries/index.html.erb"
  end


  #Displays the entry create page
=begin
  def create
    templateId = params[:template_id]
    @template = Template.find(templateId)
    render :template => "/entries/create.html.erb"
    
  end
=end

  def create
      puts "In entries#create, params=#{params}"
      entry_type_id = params[:entry_type]

      @entry_type = EntryType.find(entry_type_id)

      template_name = @entry_type.template.name

       
      @entry = initialize_entry(@entry_type, @entry_type.properties)
      @context = {:display_mode => 'new'   
                 }
       


      template = "/templates/predefined/#{template_name}.html.erb"
      entry_html = render_to_string(:template=>template, 
                                    :layout=>false,
                                    )

      


      render :json => {
            :entry_html => entry_html
      }
  end



  #Create an empty entry for a given entry_type
  #The entry_id is 0, and value=entry_type.default_value
  def initialize_entry(entry_type, entry_type_properties)
      puts "IN create_new_entry, entry_type=#{entry_type}, entry_type_properties=#{entry_type_properties}"
      entry = Hash.new
      entry_properties_map = Hash.new
      entry_type_properties.each do |property|
        propMap = {
            :id    => property[:id],
            :entry_id => 0,
            :entry_type_id => entry_type[:id],
            :label => property[:name],
            :data_type  => property[:data_type],
            :value => property[:default_value],
            :options => property[:options],
            :unit => property[:unit],
            :display_mode => "edit"
        }
        entry_properties_map[property.name.to_sym] = propMap
      end
      entry[:properties] = entry_properties_map

      return entry
  end




  # Save an entry
  # Only handles the Ajax call right now
  def save
    puts "params=#{params}"
    @entry = saveEntry(params)


    entryId = @entry.id
    
    puts "entryId=#{entryId}"
    @template = @entry.template
    @fieldValues = @entry.fieldValues.includes(:field, :field_metadata)

    context = params
    context[:entry_id] = entryId
    context[:entry] = @entry
    context[:mode] = 'display'
=begin 
    htmlBlocks = Hash.new

    @fieldValues.each do |fieldValue|
        if fieldValue.field[:fieldtype] == 't_association_list'
            associatedTemplateId = fieldValue.field.list_descriptor[:item_type_id]
            associatedEntries = getAssociatedEntries(@entry.id, associatedTemplateId)
            entriesHtml = getListHtml(associatedEntries)
            htmlBlocks[fieldValue.id] = getListHtml(associatedEntries)
        end

    end
=end
    context[:field_values] = @fieldValues
    context[:entry]  = @entry
   #context[:html_blocks] = htmlBlocks

    entryHtml = getEntryHtml(context)

    
    #redirect_to :controller=>"/entries",
    #            :action=>"get",
    #            :id => @entry.id

 
    if request.xhr?
        render :json => {:context=>context, :entry_html => entryHtml }
    end

 end


  def associate
    addAssociatedEntry(params[:entry_id], params[:associated_entry_id])
    associated_entries = getAssociatedEntries(params[:entry_id], nil)
    
    html = render_to_string(:template => "entries/_associated_entries.html.erb",:locals=>{:associated_entries=>associated_entries},  :layout=>false); 
    if request.xhr? 
       render :json => {:html=> html, :associated_entries => associated_entries} 
    end 
  end


  def new
    
    template = Template.find(params[:template_id])
   
    context = Hash.new
    context[:mode] = 'new'
    context[:template_id] = template.id
   
    entry = Entry.new
    entry.template_id = params[:template_id]
    entry.title = params[:title]
    entry.entry_type = 'templated'


    template.fields.each do |field|
        fieldValue = FieldValue.new(:attributes=>{:field_id=>field.id, :value=>''})
        entry.fieldValues.push(fieldValue)
     end

    entry.save
    context[:entry_id] = entry.id
     
    entryHtml = getEntryHtml(context)
    


    if request.xhr?
        render :json => {:entry_html => entryHtml, :context=>context }
    end
        
  end


  #Support Ajax calls only 
  def get
    puts "In entries#get, params=#{params}"
    context = params
    context[:entry_id] = params[:id]
    context[:mode] = 'display'
    context[:view_type] = "table"

    @entryHtml = getEntryHtml(context)
    if request.xhr? 
        render :json => {:html => @entryHtml, :context => context}
    else
        render :template => "/entries/get.html.erb"

    end

  end

  def show
    puts "In entries#show, params=#{params}" 
    entryId = params[:id] 
    puts "entryId=#{entryId}"

    context = params
    context[:entry_id] = params[:id]
    context[:mode] = 'display'
    context[:view_type] = 'table'
    
    @entry = Entry.find(entryId)
    @entryHtml = getEntryHtml(context)
    render :template => "/entries/show.html.erb"

  end


  def list

    templateId = params[:template]

    if templateId != nil
        @entries = Entry.includes(:fieldValues).where(:template_id=>templateId)
    else
        @entries = Entry.includes(:fieldValues).all
    end


    fields = Hash.new

    @entries.each do |entry|
        fieldValues = entry.fieldValues
        fields[entry.id] = fieldValues    

    end
     
    if request.xhr?
        render :json => {:entries => @entries, :fieldValues => fields}
    else 
        render :template => "/entries/list.html.erb"
    end
  end


  def delete
    entryId = params[:id]
    status = Entry.delete(entryId)
    if request.xhr?
        puts "It's Ajax delete."
        #render :json => {:status => 'OK', :entry_id => entryId }
        render :partial => "/shared/delete_list_item", :locals=>{:entry_id=>entryId}
    end
  end

  def add

  end


  def getRelatedEntries(entryId)

  end

end
