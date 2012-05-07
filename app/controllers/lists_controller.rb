class ListsController < ApplicationController

 
  def newItem
    puts "lists/newItem: context=#{params[:context]}"
    listId = params[:id]
    listDescriptor = ListDescriptor.find(listId)

    if listDescriptor[:item_class] == 'Entry'
        if listDescriptor[:list_type] == 'association'
            if listDescritpor[:associated_entry_id] == 0

            end

        end
        templateId = listDescriptor[:item_type_id]
        @template = Template.find(templateId)
        fields = @template.fields.includes(:list_descriptor)
        @fieldValues = Hash.new
       
        redirect_to :controller=>"/templates",
                    :action=>"get",
                    :id=>templateId,
                    :p_field_id=>params[:p_field_id],
                    :p_template_id=>params[:p_template_id]
       


    end 

  end

  def saveItem
   puts "lists/saveItem called, params=#{params}"

   #if the entry is in an associated list
   if params[:is_associated_entry] == 'true'


   end

   listId = params[:id]
   listDescriptor = ListDescriptor.find(listId)

   if listDescriptor[:item_class] == 'Entry'
    @entry = saveEntry(params)

   end
 end

end
