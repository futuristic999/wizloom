$(document).ready(function() {

    $(".with_prompt").click(function(){
        $(this).attr("value", ""); 
        $(this).removeClass('with_prompt'); 
    }); 

    $("#add_field option").click(function(event) {
        var selected_type = $("#add_field option:selected").attr("value"); 
        console.log("add_field clicked, selected=" + selected_type);
        var inputHtml = getNewField(selected_type);

        var newRow = $("<tr id='0'></tr>").addClass('t_field_row'); 
        var labelTd = $("<td></td>").addClass('label_cell');
        labelTd.append($("<div></div>").addClass("t_label").addClass("initial_mode").html("Click to Edit Label")); 

        var inputTd = $("<td></td>").addClass("input_cell"); 
        inputTd.append($("<div></div>").addClass("field_input").append($(inputHtml)));
        
        newRow.append(labelTd); 
        newRow.append(inputTd);  

        //console.log("newRow.html="+newRow.html()); 
        $(".t_table").append(newRow); 
    });

    $("#save_template_button").click(function(event) {
        console.log("save_template_button clicked"); 
        var template = processTemplateHtml(); 

        $.ajax({
              url: "/templates/save",
              data: {'template' : template},
              type: "POST",
              success: function(data){
                 if(data['status']=='OK') {
                     var templateId = data['template_id']; 
                     console.log("templateId = " + templateId); 
                     $("#main_content_container").html(
                        "<div class='status'>New Template " + templateId + " created.</div>" +  
                        "<p><a href='/entries/new?template=" + templateId + "'>" + "Create a new entry using this template</a></p>"
                        );  
                     //window.location.replace(getTemplateUrl); 
                 }
                 //$("#main_content_container").html(data['html']);    
              }
        });
    });
    
    $(".auto_populate_button").live({
        
        click: function(){
            console.log("auto_populate_button clicked");
         
            $.ajax({
                url: "/templates/list", 
                type: "GET",
                success: function(data) {
                    console.log("Ajax success, data="+data); 
                    var templates = data["templates"]; 
                    var i=0; 
                    for (i=0; i<templates.length; i++){
                        var template = templates[i]; 
                        console.log("template.name="+template["name"]); 
                    }
                }
            }); 
        }
    }); 



    $(".preview_auto_populate").live({
        click: function(){
            console.log("preview_auto_populate clicked. ");
            var parent = $(this).parents('.t_field_row'); 
            var tSelect = parent.find('.t_autolist_select'); 
            //console.log("tSelect="+tSelect.html()); 
            tSelect.children().remove(); 

            var templateId =  $(".auto_list_select option:selected").attr("value"); 
            console.log("selected templateId="+templateId); 

            $.ajax ({
                url: "/entries/list?template="+templateId,
                type: "GET",
                async: false,
                success: function(data) {
                    console.log("preview_auto_populate Ajax success. data="+data);    
                    var entries = data["entries"]; 
                    var fieldValues = data["fieldValues"]; 
                    console.log("fieldValues="+fieldValues+", length="+fieldValues.length); 

                    for (var entryId in fieldValues)
                    {   
                        var entryFieldValues = fieldValues[entryId];  
                        var i=0; 
                        for (i=0; i<entryFieldValues.length; i++) {
                            var fieldValue = entryFieldValues[i]; 
                            var label = fieldValue["label"]; 
                            if(label.toUpperCase()=='NAME' || label.toUpperCase()=="TITLE"){
                                tSelect.append($("<option id="+entryId+">"+fieldValue["value"] + "</option>"));  
                            }
                            console.log("fieldValue.label="+fieldValue["label"]); 
                            console.log("fieldValue.value="+fieldValue["value"]); 
                        }
                    }
                }
            }); 
        }

    });
    
    $(".list_select_item_class").live({
        click: function(event) {
            var itemType = $(this).val(); 
            console.log("itemType=" +itemType); 
            
            var listSelectItem = $(this).parents('.field_config_actions').find('.list_select_item_id'); 
            console.log("listSelectItem.class="+listSelectItem.attr("class")); 
            if (itemType=='Field'){
               console.log("itemType is Field"); 
               var fieldSelect = $('#add_field').clone(); 
               fieldSelect.attr('class', 'list_select_item_id'); 
               
               listSelectItem.replaceWith(fieldSelect);
            }

            if(itemType == 'Entry') {
               var entrySelect = $("<select class='list_select_item_id'></select>"); 
               $.ajax({
                   url: "/templates/list", 
                   type: "GET", 
                   async: false, 
                   success: function(data) {
                     console.log("Ajax success for template/list");
                     var i; 
                     for (i=0; i<data['templates'].length; i++) {
                        var template = data['templates'][i]; 
                        var option = $("<option value=" + template['id'] + ">"+template["name"] + "</option>"); 
                        entrySelect.append(option);     
                     
                     }
                     listSelectItem.replaceWith(entrySelect); 
                   }

               }); 

            }
        processTemplateHtml();         
        }
    }); 


    $("#add_associated_entry").live({

        click: function(event) {
            event.preventDefault(); 
            console.log("add_associated_entry clicked."); 
            var assocEntrySelect = $("<select class='list_select_associated_entry'></select>"); 
            $.ajax({
                url: "/entries/list", 
                type: "GET", 
                async: false,
                success: function(data) {
                    console.log("Ajax success for entries/list"); 
                    for (var i=0; i<data['entries'].length; i++) {
                        var entry = data['entries'][i]; 
                        var option = $("<option value=" + entry['id'] + ">" + entry['title'] + " " + entry['id'] + "</option>"); 
                        assocEntrySelect.append(option); 
                    }
                    console.log("this.parent="+ $(event.target).html()); 

                    $(event.target).parent().append(assocEntrySelect);  

                }
            }); 
        }


    }); 

    $(".t_field_row").live({
       /*
       mousedown: function(){
	    console.log("t_field_row clicked."); 
  	    $(".t_field_row").draggable( 
               {
                 start: function() {
                    console.log("dragging started."); 
                 }
	       }
            ); 
        },
        */

        mouseenter: function(){
            if($("#template_container").hasClass("design_mode")) {
                //$(this).css('background-color', 'lightgrey');
                var lastChild = $(this).children().last(); 
                
                if(!lastChild.hasClass("_controls"))  {
                    $(this).append(
                        $("<td></td>").addClass("_controls").html(
                            "<span class='move_up' style='margin-right:5px'><a href='#'>Up</a></span>"  +
                            "<span class='move_down'><a href='#'>Down</a></span>"                      
                        )
                    );  
                }
            }
        },
	    mouseleave: function(){
	        $(this).css('background-color', 'transparent');
            if($(this).children().last().hasClass("_controls")) {
                $(this).children().last().remove(); 
            }
             
        }
    }); 


    $(".t_label").live({
        click: function() {
            console.log("label clicked..."); 
  
            var labelInput = $("<input type='text'></input>").addClass('label_input');
            $(this).replaceWith(labelInput); 
            labelInput.focus();  
        
        }
    }); 


    $(".label_input").live({

        focusout: function() {
            console.log("Mouse left label_input.");
            if($(this).hasClass('initial_mode')) {
                console.log("it's initial_mode"); 
                $(this).removeClass("initial_mode"); 
                $(this).attr("value", ""); 
            }

            var labelDisplay = $("<div></div>").addClass("t_label"); 
            labelDisplay.html($(this).attr("value")); 
            $(this).replaceWith(labelDisplay); 
        }
     }); 
    
    //delete clicked a field
    $(".delete").live({
        click: function() {
            console.log("delete clicked."); 
            var parent = $(this).parents(".add_field_row");
	        console.log("parent="+parent); 
            parent.remove();  
	}
    });     

   $(".move_up, .move_down").live({
        click: function(){
            console.log("move_up or move_down clicked." );
           
            var curRow = $(this).parents(".t_field_row");
            console.log('this.parent='+$(this).css('class')); 
            
            if($(this).hasClass('move_up')){
                console.log("move_up called."); 
                if(curRow.prev()) {
                    curRow.insertBefore(curRow.prev()); 
                }
            } else{
                console.log("move_down called."); 
                if (curRow.next()) {
                     curRow.insertAfter(curRow.next()); 
                }
            }
	}
   });  
     

    
    function processTemplateHtml(){

        var template = {};
        
        var templateId = $(".template").attr("id"); 
        console.log("templateId=" + templateId); 
         
        var templateName = $("#template_name_input").attr("value"); 
        console.log("templateName="+templateName); 

        var templateHTML = $("#template_design_container").html();
        
        var tTable = $(".t_table").clone(); 

        var html = "<table class='template_table'>"; 
        //var row = $("tTable .t_field_row:first-child");
        var row = tTable.find(".t_field_row:first-child"); 
        var pos = 1;



        var fields = {}; 
        while(true){

            if(row.hasClass("t_field_row")) {
                
                 
                console.log("It's a field!"); 
                var field = {}; 

                var field_id = row.attr("id");
                if(field_id == '0') {
                    row.attr("id", "<%= _fields[:ID_"+pos +"] %>"); 
                }
                var labelDiv = row.find('.t_label'); 

                var label = labelDiv.html();  
                console.log('label='+label);
                labelDiv.attr("id", "LABEL_"+pos); 
                labelDiv.html("<%= _fields[:LABEL_"+pos+"] %>"); 

                var fieldInput = row.find('.field_input'); 
                 
                var divClass = row.find('.form_field').attr('class');  
                var field_type = divClass.substring("form_field".length, divClass.length).trim(); 
                
                console.log('field_type='+field_type); 
                
                var autoListId = 0; 
                var listItemClass = "";  
                var listItemId = ""; 
                var listAssociatedEntryId = 0; 
                var listDescriptor = {}; 
                 
                if (field_type == 't_autolist_select') {

                    //Need to go to the orignal element (not the clone) to get selected value
                    var origRow = $(".t_table .t_field_row:nth-child("+pos+")"); 
                    
                    var autoListSelect = origRow.find(".auto_list_select"); 
                    console.log("autoListSelect="+autoListSelect.html()); 
                    autoListId = autoListSelect.val();
                    console.log("autoListId="+autoListId); 

                }
                if (field_type == 't_list') {
                    
                    var origRow = $(".t_table .t_field_row:nth-child("+pos+")");
                    var listClassSelect = origRow.find(".list_select_item_class"); 
                    listItemClass = listClassSelect.val(); 
                    listDescriptor['item_class'] = listItemClass;

                    console.log("listItemClass="+ listItemClass);    
                    listItemId = origRow.find(".list_select_item_id").val();
                    listDescriptor['item_type_id'] = listItemId; 
                     
                    console.log("listItemId="+listItemId); 
                    listAssociatedEntryId = origRow.find(".list_select_associated_entry").val();
                    listDescriptor['associated_entry_id'] = listAssociatedEntryId; 
                    field['list_descriptor'] = listDescriptor; 
                }       

                fieldInput.html("<%=  _fields[:INPUT_"+pos+"] %>"); 

                field['id'] = field_id; 
                field['label'] = label;
                field['fieldname']  = label; 
                field['fieldtype'] = field_type; 
                field['display_order'] = pos; 
                field['auto_list_id'] = autoListId;
                field['list_descriptor'] = listDescriptor; 
                fields[pos] = field;               
                


                pos++; 
                row = row.next(); 
            }else{
                console.log("End of fields"); 
                break;
            }

        }
        //html += "</table>"; 
        html = tTable.html(); 
        template['id'] = templateId; 
        template['name'] = templateName;
        template['fields'] = fields;
        template['stub_html'] = "<table class='t_table'>"+html+"</table>"; 

        return template; 
    }



    //Replace LABEL with LABLE_<pos> and
    //INPUT with INPUT_<pos>
    function cleanFieldHtml(fieldHtml, pos) {
        html = fieldHtml
    }

    function processJSON(data){
        console.log("In processJSON..."); 
        var html = data['template']['html']; 
        var fields = data['fields']; 
        

    }


    function getFieldHtml(label, fieldtype, pos) {
        console.log("In getTemplateHtml(), label="+label+", type="+fieldtype); 
        var html = ""; 
        //var inputHtml = getNewField(fieldtype); 
        html += "<tr id='" + pos + "'" + " class='field_row'>"; 
        html +=   "<td class='form_label_td'></td> " ; 
        html +=      getNewField(fieldtype) ; 
        html +=   "<td class='form_field_td'></td>" ; 
        html += "</tr>";  
        return html; 
    }


    function getNewField(field_type, data) {
        console.log("In getNewField, type="+field_type);
        var input = "";
        switch(field_type)
        {
	   case 't_text':
	      console.log("it's text field");
	      input = "<input type='text' class='form_field t_text' />"; 
	      break;

	   case 't_textarea':
	      console.log("it's textarea");
	      input = "<textarea class='form_field t_textarea'></textarea>";	
	      break;

       case 't_number':
	      input = "<input type='text' class='form_field t_number' /> " +
			"<span class='t_unit_edit'>Add Unit</span>";
	      break;

       case 't_url':
           input = "<input type='text' class='form_field t_url' />"
           break; 
          
       case 't_location':
           input = "<input type='text' class='form_field t_location' />"
           break;
          
       case 't_association':
            input = "<input type='text' class='form_field t_association' />" +
                    "<span>Select a Type: </span><select class='entry_types'><option value='Select the Type'></select>"; 
            break;           
     
       case 't_link': 
            input =  "<div style='margin-bottom:2px'><span>Select a Template: </span><select class='template_select'><option value=''></select></div>"+ 
                "<span>Select an Entry : <span><select class='entry_select'><option value='Select an Entry'></select>"; 
            break;
                 
       case 't_autolist_select': 
            input = "<select class='form_field t_autolist_select'>" + 
                      "<option value=''></option>" + 
                    "</select>" + 
                    "<div class='field_config_actions'> "  + 
                        "<div class='auto_populate'>Auto Populate the List with This Type of Entries: "+
                            getAutoPopulateSelect() + 
                        "<span class='preview_auto_populate save_button'>Preview</span> </div> " + 
                    "</div>"; 
            break;  
       case 't_dropdown':
 	      input = "<select class='form_field t_select' >"+
                        "<option value=''></option>" + 
                      "</select>";
       break;
   
       case 't_datetime':
          input = "<input type='text' class='form_field t_date' value='/MM/DD/YYYY HH:MM:SS' /> ";  
	   break;	     
       
       case 't_list':
          input = "<div class='form_field t_list'></div>"; 
          input += "<div class='field_config_actions'>"; 
          input += "<div> Class <select class='list_select_item_class'>" + 
                    "<option value='Field'>Field</option>" + 
                    "<option value='Entry'>Entry</option>" +
                  "</select></div>"; 
          ///input += "&bnsp;&nbsp;"; 
          input += "<div style='margin-top: 5px;'>Template: <select class='list_select_item_id'>" + 
                     "<option value=''></option>" + 
                   "</select></div>"; 
          input += "<div><a href='' id='add_associated_entry'>Add Associated Entry</a>"; 
          input += "</div>";
        break; 
        
        case 't_assoc_list':
          input = "<div class='form_field t_assoc_list'></div>"; 
          input += "<div class='field_config_actions'>"; 
          input += "<select class='primary_entry'></select>"; 
          input += "<select class='list_select_item'>" + 
                      "<option value=''></option>" + 
                   "</select>"; 
          input += "</div>";  
          
       break; 

	}

       return input; 
    }


    function getAutoPopulateSelect() {

        var html = "<select class='auto_list_select'><option value=''>Select an Entry Type</option>"; 


        $.ajax({
                url: "/templates/list", 
                type: "GET",
                async: false,
                success: function(data) {
                    console.log("Ajax success, data="+data); 
                    templates = data["templates"];
                    var i = 0; 
                    for (i=0; i<templates.length; i++) {
                       var template = templates[i];
                       console.log("template.id="+template["id"]); 
                       console.log("template.name="+template["name"]);  
                       html = html + "<option value="+template["id"] + ">" + template["name"] + "</option>";   
                       console.log("#### html = " + html);  
                    }
                }
        }); 
        
        html = html + "</select>";

        console.log("@@@@@@@@ html="+html); 
        return html;  
    }
});



