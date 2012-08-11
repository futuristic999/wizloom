

function saveEntry(templateContainer, template_id, callback) {
    console.log("In entries.saveEntry"); 
    var url = "/entries/save"; 

    var data = processHtml(templateContainer); 
    data['template_id'] = template_id;
   
     $.ajax({
        url : url,
        type : "POST", 
        data : data, 
        success: callback

      });  

}

function addAssociation(entryId, assocEntryId, callback){
    console.log("In addAssociation"); 
    console.log("entryId=" + entryId + ", assocEntryId=" + assocEntryId); 

    var url = "/entries/handle?action=associate&entry_id=" + entryId+"&assoc_entry_id="+assocEntryId); 
    $.ajax({
        

    }); 


}


$(document).ready(function() {
    var primaryEntryId = 0; 

    console.log("In entries.js document ready()");


    $("#select_template option").click(function(){

        var templateId = $("#select_template option:selected").attr("value"); 
        console.log("templateId selected is " + templateId);
        showTemplate(templateId, $("#editor_wrapper"));  
    }), 


    /*
    $(".save_entry_button").live({
       click : function(event) {
          event.preventDefault(); 
          var url = $(this).attr("href");
          console.log("url="+url);
                         
          var id = $(this).attr("id");
          var tokens = id.split("_");
          var templateId = tokens[tokens.length-2];
          var entryId = tokens[tokens.length-1];
          console.log("entryId="+ entryId);
          var entryContainer = $("#entry_container_" + entryId);
          var templateContainer = entryContainer.children(".template_container");
          console.log("entryContainer="+entryContainer.html());
          var data = processHtml(templateContainer);
          data['entry_id'] = entryId;
          data['template_id'] = templateId;
          data['url'] = url; 
           
          saveEntry(data, function(result) {
            console.log("saveEntry callback function called!");
            console.log("result=" + result); 
            var entryHtml = result['entry_html']; 
            var entryId = result['context']['entry_id']; 
            console.log("entryId=" + entryId); 
            window.location.replace("/entries/get/"+entryId);
                 
          });                                                                                                                        
           
       }, 
       dblclick: function(event){
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
                    //templateContainer.remove(); 
                     
                    var listId = context['list_id']; 
                    var listContainerId = "list_items_" + listId;
                    console.log("listContainerId="+listContainerId);
                    var listContainer = $('#'+listContainerId); 
                    console.log("listContainer=" + listContainer);
                    $('#'+listContainerId).prepend(data['entry_html']);
                    $("#entry_container_0").dialog("close"); 
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
    */


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
             console.log("editorWrapper="+ editorWrapper);  
             editorWrapper.attr("class", "template_container");
             editorWrapper.attr("id", "template_container_"+data['context']['template_id']); 
             
             entryContainer.append(editorWrapper); 
              
             entryContainer.dialog({height:550, width:800});  
             //$(event.target).parent().append(editorWrapper);  
           }


        })

    }
   }),


   $(".delete_list_item").live({
     click: function(event) {
        event.preventDefault(); 
        console.log("delete_list_item clicked."); 
        var url = $(this).attr("href"); 
        console.log("url="+url); 
        $.ajax({
            url: url,
            dataType: "script",
            type: "GET",
            success: function(data){
                console.log("Ajax success for " + url); 
            }
        }); 
     }
   }),

   $(".save_list_item").click(function(event){
      console.log("save_list_item clicked."); 
      event.preventDefault(); 
      var listDescriptor = $(this).attr("id"); 
      console.log("listDescriptor="+listDescriptor); 
        
       
   })

}); 


function deleteListItem(listItemId) {
    console.log("In deleteListItem, listItemId=" + listItemId); 
    var listItem = $("#list_item_" + listItemId); 
    listItem.remove(); 
}


function showTemplate(templateId, parentContainer){
        console.log("In showTemplate"); 
        $.ajax({
           // url: "/templates/get/"+templateId,
            url: "/entries/new?template_id="+templateId+"&create=true&title='New Entry for Template "+templateId+"'",
            type: "GET", 
            success: function(data) {
                console.log("Ajax success in showTemplate"); 
                console.log(data); 
                var context = data['context']; 
                var entryId = context['entry_id']; 
                console.log("entryId=" + entryId); 
                var entryHtml = data['entry_html'];

                var entryContainer = parentContainer.find(".entry_container"); 
                if(entryContainer.length > 0) {
                    entryContainer.remove(); 
                }
                entryContainer = $("<div></div>").addClass("entry_container"); 
                entryContainer.attr("id", "entry_container_" + entryId); 
         
                   
                var templateContainer = $("<div></div>").addClass("template_container").html(entryHtml);  
                templateContainer.attr("id", "template_container_" + context["template_id"]); 

                entryContainer.append(templateContainer); 
                //var templateContainerDiv = $("<div></div>").addClass("template_container"); 
                //templateContainerDiv.attr("id", "template_container_"+templateId).html(templateHtml);   
                //parentContainer.children().replaceWith(templateContainerDiv); 
                console.log("parentContainer=" + parentContainer.html());  
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
    console.log('--fieldValue='+fieldValue); 
    
    var fieldInput = $(formField).parents(".field_input"); 
    console.log("fieldInput = "+ fieldInput); 
    var fieldId = fieldInput.attr('id'); 
    console.log("fieldId=" + fieldId); 
    
    var mdKey; 
    var mdValue;
    var isMetadataField = false;

    if (fieldValueId.indexOf("_") != -1) {
      console.log("IisMetadataField is true!"); 
      isMetadataField = true;
      var tokens = fieldValueId.split("_"); 
      fieldId = tokens[0]; 
      mdKey = tokens[1];    
    }
    

    
    if (fields[fieldId] == null) {
      fields[fieldId] = {}; 
      //fields[fieldId]['fieldvalue_id'] = 0; 
      fields[fieldId]['metadata'] = {};     
    }

        //fields[fieldId]['metadata'][mdKey] = fieldValue;
    if (isMetadataField == false) {
        fields[fieldId]['value'] = fieldValue;
        console.log( "fields[fieldId]['value'] = " + fieldValue);
        fields[fieldId]['fieldvalue_id'] = fieldValueId;
    }
   
     
  }

  data['fields'] = fields;
  data['template_id'] = templateId;

  return data;
}


function addListEntry(listId, entryHtml) {
    console.log("In addListEntry()"); 
    $("#"+listId).appendChild($(entryHtml)); 
    
}


