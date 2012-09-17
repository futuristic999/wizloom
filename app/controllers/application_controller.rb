class ApplicationController < ActionController::Base

    helper :all
    helper_method :getListHtml
    helper_method :getEntryHtml
    helper_method :getBlockHtml
    helper_method :getFeedsHtml
    helper_method :get_entries
    helper_method :get_entry_types


    def get_entries(filter)
        puts "In ApplicationController.get_entries"
        return Entry.all
    end


    def get_entry_types(filter)
        return EntryType.all
    end

    def saveEntry(params)
        puts "ApplicationController.saveEntry called. params=#{params}"


        templateId = params[:template_id];
        template = Template.find(templateId)
        fields = template.fields
            
        #title = "#{template.name} Entry"
        title = getEntryTitle(template, fields, params[:fields])
                   
        cachedHtml = params[:html];
        
        if (params.has_key?(:entry_id) && params[:entry_id] != '0') 
            @entry = Entry.find(params[:entry_id])
            if params.has_key?(:title) 
                @entry.title = params[:title]
            end
        else                    
            @entry = Entry.new(
                :template => template,
                :title => title,
                :entry_type => "templated",
                :body => cachedHtml,
                :refresh_html => true,
                :creator => 1,
                :status => "ACTIVE",
            )
        end

        @entry.save

        fieldsData = params[:fields]
        
        fieldValues = Array.new
        fieldsData.each do |fieldId,fieldData|

            saveFieldValue(@entry.id, fieldId, fieldData)
            
        end

                
        @entry.save
       
        if params.has_key?(:p_entry_id)
            addAssociatedEntry(params[:p_entry_id], @entry.id)
        end
       

       return @entry
    end





    def saveFieldValue(entryId, fieldId, fieldData)
       puts "In saveFieldValue"
       field = Field.find(fieldId)
       entry = Entry.find(entryId)
        
       if field.fieldtype == 't_list'
        fieldValue = FieldValue.where({:entry_id=>entryId, :field_id=>fieldId})
        if fieldValue==nil
            fieldValue = FieldValue.new(:field_id=>fieldId, :value=>'')
            fieldValue.save
        end
        #save the templated Data


       else

           fieldValue = entry.fieldValues.where({:field_id=>fieldId})
            puts "fieldId=#{fieldId}, fieldValue=#{fieldValue}" 

           if fieldValue.first == nil
                fieldValue = FieldValue.new({:field_id=>fieldId,:entry_id=>entryId,:value=>fieldData[:value]})

                if fieldData[:metadata] != nil
                    fieldData[:metadata].each do |mdKey,mdValue|
                    fieldValue.field_metadata.push(FieldMetadata.new({:key=>mdKey, :value=>mdValue}))
               end
            end
            fieldValue.save

           else 
            
                fieldValue.update_all(:value => fieldData[:value])

          end
       end
       


    end

    def getEntryTitle(template, fields, fieldValues)
        puts "in getEntryTitle, fieldValues=#{fieldValues}"
        title = "[#{template.name}]"
        titleValue = ""

        fields.each do |field|
            if field.label.upcase == 'NAME' || field.label.upcase == 'TITLE'
                puts "title field.id=#{field.id}"
                key = "'#{field.id}'"
                titleValue = fieldValues[field.id.to_s]['value']
                break
            end
        end

        if titleValue == ""
            firstFieldId = fieldValues.keys[0]
            titleValue = fieldValues[firstFieldId]['value']
        end 

        title = "#{title} #{titleValue}"
        return title

    end

    def getTemplateHtml(templateId, params)
      puts "In ApplicationController.getTemplateHtml, templateId=#{templateId}"
      @template = Template.find(templateId)
      fields = @template.fields.includes(:list_descriptor)

      @fieldValues = Hash.new
      @mode = 'new'      
      templateHtml = render_to_string(:template=>"templates/table_format.html.erb", 
                                      :layout=>false,
                                      :params=>params)
      
      return templateHtml

    end

    def paramsToUrl(params)
        elems = []
        params.each do |key,value|
            if key != 'controller' && key != 'action'
                elems << "#{key}=#{value}"
            end
        end
        return elems.join('&')
    end
    
    def getEntryHtml(params)
        puts "In getEntryHtml(), params=#{params}"
        if params.has_key?(:entry) 
            @entry = params[:entry]    
            #@fieldValues = params[:field_values]
        else    
            entryId = params[:entry_id] 
            @entry = Entry.find(entryId)
            #@fieldValues = @entry.fieldValues.includes(:field, :field_metadata)
        end

        @fieldValues = @entry.fieldValues.includes(:field, :field_metadata)

        viewType = params['view_type']
        mode = params[:mode]
        
        context = params
=begin
        if @entry.entry_type == 'list'
            listDescriptor = JSON.parse(@entry.descriptor)
            @entries = getListEntries(listDescriptor)
            
            if params.has_key?('view_type')
                viewType = params['view_type']
            else
                viewType = 'list_title'
            end
                
            entryHtml = render_to_string(
                :template => "/entries/#{listDescriptor['item_class']}_#{viewType}.html.erb",
                :layout => false, 
                :context => context
            )
        end

=end            
               

        if @entry.entry_type == 'templated'
            puts "entry_type is templated"
            @context = params
            @fields = @entry.template.fields
            @template = @entry.template            
            @mode = mode
             
             
            @context[:params_url] = paramsToUrl(@context)
            
            puts "@context[:params_url] =  #{@context[:params_url]}"
            
            if @context.has_key?(:main_view_type) == false
                @context[:main_view_type] = @context[:view_type]  
            end 

            if @context.has_key?(:view_type)
                template = "/entries/#{@context[:view_type]}_format.html.erb"
    
            else
                template = "/entries/table_format.html.erb"
            end
            puts "template is #{template}" 
            puts "fieldValues=#{@fieldValues}"
             
            @fieldValues.each do |fieldValue| 
                puts "fieldValue=#{fieldValue}"
                #puts "*** fieldValue.id=#{fieldValue.id}, fieldId=#{fieldValue.field.id}"
                if fieldValue.field != nil && fieldValue.field[:fieldtype] == 't_association_list'
                  puts "fieldValue.field[:fieldtype] is _t_association_list"
                  associatedTemplateId = fieldValue.field.list_descriptor[:item_type_id]
                  associatedEntries = getAssociatedEntries(@entry.id, associatedTemplateId)
                  puts "associatedEntries=#{associatedEntries}"
                  fieldKey = "field_#{fieldValue.id}"
                  @context[fieldKey.to_sym] = Hash.new
                  listContext = Hash.new
                  listContext[:mode] = 'display'
                  @context[fieldKey.to_sym][:associated_entries] = associatedEntries
                end
            end
            
            #template = "/entries/#{@context[:main_view_type]}_format.html.erb"; 
            puts "Before rendering, @context[fieldValue.id]=#{@context}"
            entryHtml = render_to_string( 
                      :template => template,
                      :layout => false
                      )

        end
        puts "entryHtml=#{entryHtml}" 
        return entryHtml
    end



    def getListHtml(entries, context)
        puts "--------------------in getListHtml() --------------------"
        html = ""
        #entries_short = Array.new
        #entries_short[0] = entries[1]

        entries.each do |entry| 
            context[:entry_id] = entry.id
            context[:mode] = 'display'
            entryHtml = getEntryHtml(context)
            if entryHtml != nil 
                html = html + entryHtml
            end
        end
        puts "---------------------end of getListHtml() ---------------"
        puts "html=#{html}" 
        return html
    end

    def getListEntries(params)
        entries = Array.new
        if params[:item_class] == 'entry'
            templateId = params[:item_type_id]
            entries = Entry.where(:template_id=>templateId).order("created_at DESC")
        end
        return entries

    end

    def addAssociatedEntry(entryId, associatedEntryId)
       puts "In addAssociatedEntry: entryId=#{entryId}, associatedEntryId=#{associatedEntryId}" 
       a = EntryAssociation.new(attributes={:entry_id=>entryId, :associated_entry_id=>associatedEntryId})
       a.save
    end

    def getAssociatedEntries(entryId,associatedEntryTemplateId)
       if associatedEntryTemplateId == nil 
         entries = Entry.find(entryId).associated_entries
       else 
         entries = Entry.find(entryId).associated_entries.where(:template_id=>associatedEntryTemplateId)
       end
       return entries
=begin
       entries = Hash.new
       

       allAssociatedEntries = Entry.find(entryId).associated_entries

       allAssociatedEntries.each do |associatedEntry|
         if associatedEntry.template_id == associatedEntryTemplateId
             entries[associatedEntry.id] = associatedEntry
         end
       end
       return entries
=end    
    end



  def getBlockHtml(params)
    puts "In getBlockHtml, params=#{params}"
    if params.has_key?(:block) 
        @block = params[:block]
    else 
        @block = Block.find(params[:block_id])
    end

    puts "view_type = #{@block[:view_type]}" 

    #if @block[:view_type] =='list_full' || @block[:view_type] =='list_title'
        params = {:item_class=>'entry', :item_type_id=>@block[:template_id]}
        context = params
        context[:view_type] = @block[:view_type]

        @entries = getListEntries(params)
        puts "template_id=#{@block[:template_id]}, entries are : #{@entries}" 
        
        templateFile = "#{@block[:entry_type]}_#{@block[:view_type]}.html.erb"

        blockHtml = render_to_string(:template=>"/blocks/configured/#{templateFile}",
                        :layout =>false,
                        :locals => {:context => context})
    #end

    return blockHtml
    
  end


  def getFeedsHtml(topics) 
    puts "getFeedHtml(), topics=#{topics}" 
    return "<P>Feeds here..."
  end

=begin

  def getBlockHtml(blockId, params)
      @block = Block.find(blockId)
      mode = params[:mode]
      if params.has_key?(:mode) == false || mode == 'edit' || mode == 'display'
          @mainEntryId = params[:main_entry_id]
      else
          @mainEntryId = 0
      end
      
      params[:saveUrl] = "/blocks/handle?instruction=save&block_id=#{@block.id}&template_id=#{@block.template.id}&main_entry_id=#{@mainEntryId}"

      params[:saveButtonClass] = "block-save-entry-button save_button"
      
      blockTemplate = "blocks/configured/#{@block.entry_type}_#{@block.view_type}.html.erb"
      
      editorHtml = ""
      if @block.view_type == 'main' && params[:mode] == 'display'
            editorHtml = getEntryHtml(@mainEntryId, params)
      else
            editorHtml = getTemplateHtml(@block.template.id, params)
      end
      params[:editorHtml] = editorHtml

      params[:entries] = getBlockEntries(@block, params)

      blockHtml = render_to_string(:template=>blockTemplate, :layout=>false, :params=>params)
      return blockHtml

  end
=end
  def getBlockEntries(block, params)
    entries = Array.new
    if params.has_key?(:main_entry_id) == false
        return entries
    end

    mainEntryId = params[:main_entry_id]

    if block.view_type == 'main'
        entry = Entry.find(mainEntryId)
        entries.push(entry)
    end

    if block.view_type == 'association_list'
        entries = getAssociatedEntries(mainEntryId, block.template.id)
    end
    
    return entries

  end



end

