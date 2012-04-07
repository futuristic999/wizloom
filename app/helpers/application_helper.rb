module ApplicationHelper
=begin
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
     if field.fieldtype == 't_list' 

       listItemType = field[:list_item_type]
       listItemDescriptor =   field[:list_item_descriptor]
       html = "<div class='t_list_actions'>" +
                "<a href='' id='add_list_item_#{listItemType}_#{listItemDescriptor}' class='add_list_item'>Add to List</a>"+
              "</div>" +
              "<div class='t_list_items'>" +
                    "<div id='t_list_item_#{listItemType}_#{listItemDescriptor}_0' class='t_list_item'>" +
                     getInputHtml({:fieldtype=>listItemDescriptor}) +
              "</div>"
     else 
        html = FIELD_INPUTS[field.fieldtype]
     end
     return html
   end
=end
end






class StyledFormBuilder < ActionView::Helpers::FormBuilder

    def populate_options_with_templates(templates)
        options = Array.new
        templates.each do |t|
            nameValue = Array.new
            nameValue.push(t.name, t.id)
        end
       super.options_for_select(options)

    end
    
end


class LabellingFormBuilder < ActionView::Helpers::FormBuilder
    def text_field(attribute, options={})
        label(attribute) + super
    end
end
