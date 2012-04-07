$(document).ready(function() {
    console.log("In entries.js document ready()");



    $("#select_template option").click(function(){

        var templateId = $("#select_template option:selected").attr("value"); 
        console.log("templateId selected is " + templateId);
        showTemplate(templateId, $("#editor_wrapper"));  
    }), 


    $("#save_entry_button").click(function(){
        console.log("save_entry_button clicked."); 
        var data = processHtml();

        
        $.ajax({
            url: "/entries/save",
            type: "POST",
            data: data, 
            success: function(data) {
                //var entry = data['entry'];
                var entry = {}; 
                entry['body'] = data;
                var entryContainer = $("<div></div>").addClass('entry_contaner').html(entry['body']); 
                $("#entries_container").prepend(entryContainer); 
                $("#editor_wrapper").css("display", "none");  
            }

        })
        
    }), 

    $(".delete_entry").click(function(){
        console.log("delete_entry clicked"); 
        var entryId = $(this).attr("id"); 

        $.ajax({
            url: "/entries/delete/"+entryId,
            type: "POST", 
            success: function(data) {
                var status = data['status']; 
                if(status == 'OK') {
                    $('#list_item_'+entryId).remove(); 
                }
            }

        })
    }),

   $(".add_list_item").live({
       click: function(event) {
        event.preventDefault(); 
        console.log('add_list_item clicked.'); 
        var listId = $(this).attr("id");
        console.log('listId='+listId); 
       
        $.ajax({
           url: "/lists/newItem/" + listId,
           type: "GET",
           success: function(data) {
             console.log("Ajax success for /lists/get");   
             var templateNode = $(data); 
             $(event.target).parent().append(templateNode);  
           }


        })

    }
   }),

   $(".save_list_item").click(function(event){
      console.log("save_list_item clicked."); 
      event.preventDefault(); 
      var listDescriptor = $(this).attr("id"); 
      console.log("listDescriptor="+listDescriptor); 
        
       
   })

}); 

function showTemplate(templateId, parentContainer){

        $.ajax({
            url: "/templates/get/"+templateId,
            type: "GET", 
            success: function(data) {
               // var template = data["template"]; 
                var templateHtml = data;
                var templateContainerDiv = $("<div></div>").addClass("template_container"); 
                templateContainerDiv.attr("id", templateId).html(templateHtml);   
               
                parentContainer.children().replaceWith(templateContainerDiv); 
                parentContainer.css("display", "block"); 
                 
                //$("#editor_wrapper").children().replaceWith(templateContainerDiv); 
                //$("#editor_wrapper").css("display", "block"); 
            }
        })
}

function processHtml() {
  var data = {};
  var fields = {}; 
  var editorDiv = $("#editor_wrapper");

  var templateContainerDiv = editorDiv.children('.template_container');
  console.log("templateContainerDiv= "+templateContainerDiv);

  var templateId = templateContainerDiv.attr("id");
  console.log("templateId="+templateId);

  var formFields = templateContainerDiv.find('.form_field'); 
  var i;
  console.log('formFields.length='+formFields.length);  
  for (i=0; i<formFields.length; i++) {
    var formField = formFields[i]; 
    console.log(formField); 
    var fieldId = $(formField).attr('id'); 
    console.log('fieldId='+fieldId);
    var fieldValue = $(formField).val(); 
    console.log('fieldValue='+fieldValue); 
    var mdKey; 
    var mdValue;

    if (fieldId.indexOf("_") != -1) {
      var tokens = fieldId.split("_"); 
      fieldId = tokens[0]; 
      mdKey = tokens[1];    
    }
    

    
    if (fields[fieldId] == null) {
      fields[fieldId] = {}; 
      fields[fieldId]['metadata'] = {};     
    }

    fields[fieldId]['metadata'][mdKey] = fieldValue;
    fields[fieldId]['value'] = fieldValue;
     
  }

  data['fields'] = fields;
  data['template_id'] = templateId;

  return data;
}
    
function processHtmlOld(){
    var data = {}; 
    var fields = {}; 

    var cachedDiv = $("<table></table>").addClass("t_table"); 

    var editorDiv = $("#editor_wrapper"); 

    var templateContainerDiv = editorDiv.children('.template_container'); 
    console.log("templateContainerDiv= "+templateContainerDiv); 

    var templateId = templateContainerDiv.attr("id"); 
    console.log("templateId="+templateId); 

    //var row = $(".t_table tr:first-child"); 
    var tTable = templateContainerDiv.find(".t_table"); 
    console.log("tTable="+tTable.html()); 

    var row = tTable.find("tr:first"); 
    //var row = $(".t_table").find("tr:first"); 
    console.log('row='+row.html());  

    while (row.hasClass("t_field_row")){
       
       var cachedRow = row.clone(); 

       var label = row.find(".t_label").html(); 
       console.log("label="+label); 


       if (row.find('.t_list_items').size() > 0) {
           console.log("found t_list_item"); 
           var listItemsDiv = cachedRow.find('.t_list_items'); 
           var listItem = listItemsDiv.find('.t_list_item:first'); 
         
           var listFieldValues = [];  
           while(listItem.hasClass('t_list_item')) { 
             console.log("listItem="+$(listItem).html());    
             
             var itemFieldInput = listItem.find(".form_field"); 
             var itemFieldValue = itemFieldInput.attr('value');  
             console.log('itemFieldValue='+itemFieldValue);
             var itemFieldClass = itemFieldInput.attr('class'); 
             console.log('itemFieldClass='+itemFieldClass); 

             itemFieldInput.replaceWith($("<div class='" + itemFieldClass + "'>" + itemFieldValue + "</div>"));   
             console.log("cachedRow="+cachedRow.html()); 
             
             listFieldValues.push(itemFieldValue); 

             listItem = listItem.next();       
           }

           fields[label] = listFieldValues;
       } else {
            var fieldValue = row.find(".form_field").attr("value"); 
            console.log("fieldValue="+fieldValue);
   
       
            var fieldInput = cachedRow.find(".field_input");
            var fieldId = fieldInput.attr("id"); 
            var fieldClass = fieldInput.attr('class'); 
            cachedRow.find(".field_input").replaceWith("<div class='"+fieldClass + "'>"+fieldValue + "</div>");
            //fields[label] = fieldValue; 
            fields[fieldId] = fieldValue;
        }
        
       cachedDiv.append(cachedRow); 


       row = row.next(); 
    }
    var html = "<table class='t_table'>" + cachedDiv.html() + "</table>"; 
    //console.log("html="+html); 

    data['html'] = html;
    //data['html'] = "<table class='t_table'>" + tTable.html() + "</table>"; 
    data['fields'] = fields; 
    data['template_id'] = templateId; 

    return data; 
}
