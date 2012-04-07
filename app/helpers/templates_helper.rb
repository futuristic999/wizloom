module TemplatesHelper

   FIELD_INPUTS = {
      't_text'      => "<input class='form_field t_text' type='text'></input>",
      't_textarea'  => "<textarea class='form_field t_textarea'></textarea>",
      't_url'       => "<input class='form_field t_url' type='text'></input>",
      't_location'  => "<input class='form_field t_location' type='text'></input>",
      't_autolist_select' => "<select class='form_field t_autolist_select'></select>",
   }


   def getFieldInputHtml(field) 
     puts "TemplatesHelper.getFieldHtml called."
     html = ""
     if field[:fieldtype] == 't_list' 
       puts "field=#{field}"
       listItemType = field[:list_item_type]
       listItemDescriptor =   field[:list_item_descriptor]
       html = "<div class='t_list_actions'>" +
                "<a href='' id='add_list_item_#{listItemType}_#{listItemDescriptor}' class='add_list_item'>Add to List</a>"+
              "</div>" +
              "<div class='t_list_items'>" +
                    "<div id='t_list_item_#{listItemType}_#{listItemDescriptor}_0' class='t_list_item'>" +
                     getFieldInputHtml({:fieldtype=>listItemDescriptor}) +
              "</div>"
     else 
        html = FIELD_INPUTS[field[:fieldtype]]
     end
     return html
   end

   def getFieldValueHtml(field,fieldValue)
     puts "In getFieldValueHtml, field=#{field}"
     puts "fieldType = #{field[:fieldtype]}" 
     html = ""
     case field[:fieldtype]
        when 't_text'
        when 't_url'
            html = fieldValue[:value]
        when 't_list' 
            html = "filedType is t_list"
        else
            print("unrecognized fieldType")
     end
    
     puts "html=#{html}"
     return html
   
   end



end
