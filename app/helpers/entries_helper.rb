module EntriesHelper

    def saveEntry
        puts '@@@@@@ EntriesHelper.saveEntry(), params=#{params}'
        templateId = params[:template_id];
        template = Template.find(templateId)
            
        title = "#{template.name} Entry"
                    
        cachedHtml = params[:html];
                            
        fieldsData = params[:fields]
        fieldValues = Array.new
        fieldsData.each do |label,fieldValue|
            fieldValue = FieldValue.new({:label=>label, :value=>fieldValue})
            puts "fieldValue=#{fieldValue}"
            fieldValues.push(fieldValue)
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

    def getFieldInputHtml(field)
        puts "EntriesHelper.getFieldInputHtml called."
    end

end
