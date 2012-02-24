$(document).ready(function() {

    $(".with_prompt").click(function(){
        $(this).attr("value", ""); 
        $(this).removeClass('with_prompt'); 
    }); 

    $("#add_field option").click(function(event) {
        var selected_type = $("#add_field option:selected").attr("value"); 
        console.log("add_field clicked, selected=" + selected_type);
        var inputHtml = getNewField(selected_type);

        var newTr = $("<tr></tr>").addClass('t_field_row'); 
        var labelTd = $("<td></td>").addClass('label_cell');
        labelTd.append($("<div></div>").addClass("t_label").addClass("initial_mode").html("Click to Edit Label")); 

        var inputTd = $("<td></td>").addClass("input_cell"); 
        inputTd.append($("<div></div>").addClass("field_input").append($(inputHtml)));
        
        newTr.append(labelTd); 
        newTr.append(inputTd);  

        console.log("newTr.html="+newTr.html()); 
        $(".t_table").append(newTr); 
        //var newFieldRowTr = $("#row_0").clone(true,true); 
        //console.log("newFiledRowTr="+newFieldRowTr); 
        
        //var editFieldInputDiv = newFieldRowTr.find(".edit_field_input"); 
        //editFieldInputDiv.html(inputHtml);

        //newFieldRowTr.attr("class", "field_row");  
        //newFieldRowTr.css("display", "table-row"); 
        //newFieldRowTr.insertAfter($("#controls_row")); 
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
            if($(".t_table").hasClass("design_mode")) {
                $(this).css('background-color', 'lightgrey');
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
            console.log("curRow=" + curRow.html()); 
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
        var templateName = $("#template_name_input").attr("value"); 
        console.log("templateName="+templateName); 

        var templateHTML = $("#template_design_container").html();

        var html = "<table class='template_table'>"; 
        var row = $(".t_table .t_field_row:first-child"); 
        var pos = 1;
        //row = row.next(); //The first row is the control_row


        //var cleanHtml = ""

        var fields = {}; 
        while(true){

            if(row.hasClass("t_field_row")) {
                
                 
                console.log("It's a field!"); 
                var field = {}; 

                var labelDiv = row.find('.t_label'); 

                var label = labelDiv.html();  
                console.log('label='+label);
                labelDiv.attr("id", "LABEL_"+pos); 
                
                var divClass = row.find('.form_field').attr('class');  
                var field_type = divClass.substring("form_field".length, divClass.length).trim(); 
                
                console.log('field_type='+field_type);  
                
                field['label'] = label;
                field['fieldname']  = label; 
                field['fieldtype'] = field_type; 
                field['display_order'] = pos; 
                fields[pos] = field;               
                
                //fieldHtml = row.html()
                //var fieldHtml = cleanFieldHtml(fieldHtml);   

                //var fieldHtml = getFieldHtml(label, field_type, pos); 
                //html += fieldHtml; 

                pos++; 
                row = row.next(); 
            }else{
                console.log("End of fields"); 
                break;
            }

        }
        //html += "</table>"; 
        html = $(".t_table").html(); 
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


    function getNewField(field_type) {
        console.log("In getNewField, type="+field_type);
        var input = "";
        switch(field_type)
        {
	   case 't_text':
           case 'url':
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
      
       case 't_dropdown':
 	      input = "<select class='form_field t_select' >"+
                        "<option value=''></option>" + 
                      "</select>";
       break;
   
       case 't_datetime':
          input = "<input type='text' class='form_field t_date' value='/MM/DD/YYYY HH:MM:SS' /> ";  
	   break;	      

	}

       return input; 
    }
});



