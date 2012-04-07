class ListsController < ApplicationController





 
  def newItem
    listId = params[:id]
    listDescriptor = ListDescriptor.find(listId)

    if listDescriptor[:item_class] == 'Entry'
       templateId = listDescriptor[:item_type_id]
        @template = Template.find(templateId)
        fields = @template.fields.includes(:list_descriptor)
        @fieldValues = Hash.new
        templateFile = "#{Rails.root}/app/views/templates/table_format.html.erb"
        html = ERB.new(File.new(templateFile).read).result(binding)
       
        return
       
        #puts "templateHtml=#{html}"  


    end 

  end

end
