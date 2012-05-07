$(document).ready(function() {
    var primaryEntryId = 0; 

    console.log("In entries.js document ready()");



    $("#select_template option").click(function(){

        var templateId = $("#select_template option:selected").attr("value"); 
        console.log("templateId selected is " + templateId);
        showTemplate(templateId, $("#editor_wrapper"));  
    }), 


    $(".save_entry_button").live({
    
       click: function(event){
        event.preventDefault(); 
        console.log("save_entry_button clicked."); 
        var url = $(this).attr("href"); 
        console.log("url="+url); 

        var id = $(this).attr("id"); 
        var tokens = id.split("_"); 

        var templateId = tokens[tokens.length-2]; 
        var entryId = tokens[tokens.length-1]; 
        console.log("entryId="+ entryId); 
        
        //var templateId = "template_container_" + id; 

        //var templateContainerDiv = $("#" + templateId); 
        //console.log("templateContainerDiv.id="+templateContainerDiv.attr("id")); 


        //var data = processHtml(templateContainerDiv);
        var entryContainer = $("#entry_container_" + entryId); 
        var templateContainer = entryContainer.children(".template_container"); 
        console.log("entryContainer="+entryContainer.html()); 
        console.log("templateContainer=" + templateContainer); 
        console.log("templateContainer.html=" + templateContainer.html());  
        var data = processHtml(templateContainer); 
        data['entry_id'] = entryId;
        data['template_id'] = templateId; 
        
        $.ajax({
            url: url,
            type: "POST",
            data: data,
            //dataType: 'script', 
            success: function(data) {
                var context = data['context']; 
                if (context['view_type'].indexOf('list')!=-1){
                    console.log("Is list"); 
                    var templateId = context['template_id']; 
                    var templateContainer = $('#'+'template_container_'+templateId); 
                    templateContainer.remove(); 
                     
                    var listId = context['list_id']; 
                    var listContainerId = "t_list_items_" + listId;
                    console.log("listContainerId="+listContainerId);
                    var listContainer = $('#'+listContainerId); 
                    console.log("listContainer=" + listContainer);
                    $('#'+listContainerId).append(data['entry_html']);
                    //$("#dialog").dialog("close"); 
                }
                else {
                    console.log("In else"); 
                    var entryId = data['context']['entry_id']; 
                    var entryHtml = data['entry_html']; 

                    var entryContainer = $("<div></div>").addClass('entry_contaner'); 
                    entryContainer.attr("id", "entry_container_" + entryId); 
                    var templateContainer = $("<div></div>").addClass("template_container").html(entryHtml); 
                    templateContainer.attr("id", "template_container_"+ data["context"]["template_id"]); 

                    entryContainer.append(templateContainer);
                    console.log("entryContainer.html=" + entryContainer.html()); 

                    var curEntryContainer = $("#editor_wrapper").children(".entry_container"); 
                    console.log("curEntryContainer="+ curEntryContainer);     

                    if (curEntryContainer != null) {    
                        console.log("curEntryContainer!=null"); 
                        curEntryContainer.remove();
                    } 
                    $("#editor_wrapper").prepend(entryContainer); 

                    //$("#editor_wrapper").css("display", "none");  
                }
            }

        })
       }
        
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
        
        var listId; 
        var fieldId;
         
        var ids = $(this).attr("id");
        saveUrl = $(this).attr("href"); 
               

        $.ajax({
           url: saveUrl,
           type: "GET",
           success: function(data) {
             console.log("Ajax success for /lists/get");   
             var templateHtml = data['html']; 
             var curEntryContainer = $("#entry_container_0"); 
             if (curEntryContainer != null) {
                curEntryContainer.remove(); 
             }
             var entryContainer = $("<div></div>").attr("class", "entry_container new_entry"); 
             entryContainer.attr("id", "entry_container_0"); 
             
             var editorWrapper = $("<div></div>").html(templateHtml); 
             editorWrapper.attr("class", "template_container");
             editorWrapper.attr("id", "template_container_"+data['context']['template_id']); 
             
             entryContainer.append(editorWrapper); 
              
             entryContainer.dialog({height:550, width:800});  
             //$(event.target).parent().append(editorWrapper);  
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
           // url: "/templates/get/"+templateId,
            url: "/entries/new?template_id="+templateId+"&create=true&title='New Entry for Template "+templateId+"'",
            type: "GET", 
            success: function(data) {
                var context = data['context']; 
                var entryId = context['entry_id']; 
                var entryHtml = data['entry_html'];
                
                var entryContainer = $("<div></div>").addClass("entry_container"); 
                entryContainer.attr("id", "entry_container_" + entryId); 
                
                var templateContainer = $("<div></div>").addClass("template_container").html(entryHtml);  
                templateContainer.attr("id", "template_container_" + context["template_id"]); 

                entryContainer.append(templateContainer); 
                //var templateContainerDiv = $("<div></div>").addClass("template_container"); 
                //templateContainerDiv.attr("id", "template_container_"+templateId).html(templateHtml);   
                //parentContainer.children().replaceWith(templateContainerDiv); 
                
                parentContainer.append(entryContainer); 
                parentContainer.css("display", "block"); 
                 
            }
        })
}

function processHtml(templateContainerDiv) {
  var data = {};
  var fields = {};    
  //var editorDiv = $("#editor_wrapper");

  //var templateContainerDiv = editorDiv.children('.template_container');
  //console.log("templateContainerDiv= "+templateContainerDiv);

  var tokens = templateContainerDiv.attr("id").split("_"); 
  var templateId = tokens[tokens.length-1]; 
  console.log("templateId="+templateId);
  
  console.log(templateContainerDiv); 

  var formFields = templateContainerDiv.find('.form_field'); 
  var i;
  console.log('formFields.length='+formFields.length);  
  for (i=0; i<formFields.length; i++) {
    var formField = formFields[i]; 
    console.log(formField);
     
    var fieldValueId = $(formField).attr('id'); 
    console.log('fieldValueId='+fieldValueId);

    var fieldValue = $(formField).val(); 
    console.log('fieldValue='+fieldValue); 
    
    var fieldInput = $(formField).parents(".field_input"); 
    console.log("fieldInput = "+ fieldInput); 
    var fieldId = fieldInput.attr('id'); 
    console.log("fieldId=" + fieldId); 
    
    var mdKey; 
    var mdValue;

    if (fieldId.indexOf("_") != -1) {
      var tokens = fieldId.split("_"); 
      fieldId = tokens[0]; 
      mdKey = tokens[1];    
    }
    

    
    if (fields[fieldId] == null) {
      fields[fieldId] = {}; 
      //fields[fieldId]['fieldvalue_id'] = 0; 
      fields[fieldId]['metadata'] = {};     
    }

        //fields[fieldId]['metadata'][mdKey] = fieldValue;
    fields[fieldId]['value'] = fieldValue;
    fields[fieldId]['fieldvalue_id'] = fieldValueId;
   
     
  }

  data['fields'] = fields;
  data['template_id'] = templateId;

  return data;
}


function addListEntry(listId, entryHtml) {
    console.log("In addListEntry()"); 
    $("#"+listId).appendChild($(entryHtml)); 
    
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
