class ApplicationController < ActionController::Base

    helper :all

    def saveEntry(params)
        templateId = params[:template_id];
        template = Template.find(templateId)
        fields = template.fields
            
        title = "#{template.name} Entry"
                    
        cachedHtml = params[:html];
                            
        fieldsData = params[:fields]
        fieldValues = Array.new
        fieldsData.each do |fieldId,fieldData|
            field = Field.find(fieldId)
            puts "fieldType=#{field.fieldtype}" 


                
            if fieldData.class == Array
                fieldData[:value].each do |itemValue|
                    fieldValues.push(FieldValue.new({:field_id=>fieldId, :value=>itemValue}))
                end

            else 
                fieldValue = FieldValue.new({:field_id=>fieldId, :value=>fieldData[:value]})
                if fieldData[:metadata] != nil
                    fieldData[:metadata].each do |mdKey, mdValue|
                        fieldValue.field_metadata.push(FieldMetadata.new({:key=>mdKey, :value=>mdValue}))
                    end

                end
                puts "fieldValue=#{fieldValue}"
                fieldValues.push(fieldValue)
            end
        end
        
        @entry = Entry.new(
            :template => template,
            :title => title,
            :body => cachedHtml,
            :refresh_html => false,
            :creator => 1,
            :status => "ACTIVE",
            :fieldValues => fieldValues
        )

       @entry.save

       return @entry
    end


    def getTemplateHtml(templateId)
      puts "In ApplicationController.getTemplateHtml, templateId=#{templateId}"
      @template = Template.find(templateId)
      fields = @template.fields.includes(:list_descriptor)

      @fieldValues = Hash.new
      templateFile = "#{Rails.root}/app/views/templates/table_format.html.erb"
      html = ERB.new(File.new(templateFile).read).result(binding)
      return html

    end


    def addAssociatedEntry(entryId, associatedEntryId)
       puts "In addAssociatedEntry: entryId=#{entryId}, associatedEntryId=#{associatedEntryId}" 
       a = EntryAssociation.new(attributes={:entry_id=>entryId, :associated_entry_id=>associatedEntryId})
       a.save
    end

    def getAssociatedEntries(entryId,associatedEntryTemplateId)
       entries = Hash.new
       

       allAssociatedEntries = Entry.find(entryId).associated_entries

       allAssociatedEntries.each do |associatedEntry|
         if associatedEntry.template_id == associatedEntryTemplateId
             entries[associatedEntry.id] = associatedEntry
         end
       end
       return entries
    end

    def getBlockHtml(blockId, mode, data) 
        @block = Block.includes(:template).find(blockId)
        @mode = mode

        if @block.view_type == 'list_full' 
            if(@block.associated_entry_id != nil) 
                @entries = Entry.find(@block.associated_entry_id).associated_entries.where({:template_id=>@block.template.id})
            end
        end
=begin
        if @block.view_type == 'new'
            @entry = data[:entry]

        end
=end        

        blockTemplate = "blocks/configured/#{@block.entry_type}_#{@block.view_type}.html.erb"

        blockHtml = ERB.new(File.new("#{Rails.root}/app/views/#{blockTemplate}").read).result(binding)
        return blockHtml
    end
    
=begin
    def getItems(params)
        listItems = Hash.new
        if params[:id] != nil

        else 
          listItemType = params[:list_item_type]
          if listItemType == 'Entry'
             associatedEntryTemplateId = params[:list_item_descriptor]
             entries = Entry.includes(:associated_entries).where(:
          end

        end
        return listItems
    end    
=end
end
