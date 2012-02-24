$(document).ready(function() {
    console.log("In entries.js document ready()");



    $("#select_template option").click(function(){

        var templateId = $("#select_template option:selected").attr("value"); 
        console.log("templateId selected is " + templateId);
        
        $.ajax({
            url: "/templates/get/"+templateId,
            type: "GET", 
            success: function(data) {
                var template = data["template"]; 
                var templateHtml = template["cached_html"];
                var templateContainerDiv = $("<div></div>").addClass("template_container"); 
                templateContainerDiv.attr("id", templateId).html(templateHtml);   
                $("#editor_wrapper").children().replaceWith(templateContainerDiv); 
                $("#editor_wrapper").css("display", "block"); 
            }
        })
    }), 

    $("#save_entry_button").click(function(){
        console.log("save_entry_button clicked."); 
        var data = processHtml();

        $.ajax({
            url: "/entries/save",
            type: "POST",
            data: data, 
            success: function(data) {
                var entry = data['entry'];
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
    })

    

}); 


    
function processHtml(){
    var data = {}; 
    var fields = {}; 

    var cachedDiv = $("<table></table>").addClass("t_table"); 

    var editorDiv = $("#editor_wrapper"); 

    var templateContainerDiv = editorDiv.children('.template_container'); 
    console.log("templateContainerDiv= "+templateContainerDiv); 

    var templateId = templateContainerDiv.attr("id"); 
    console.log("templateId="+templateId); 

    //var row = $(".t_table tr:first-child"); 
    var tTable = templateContainerDiv.children(".t_table"); 
    console.log("tTable="+tTable); 

    var row = tTable.find("tr:first"); 
    console.log('row='+row.html());  

    while (row.hasClass("t_field_row")){
       
       var cachedRow = row.clone(); 

       var label = row.find(".t_label").html(); 
       console.log("label="+label); 

       
       var fieldValue = row.find(".form_field").attr("value"); 
       console.log("fieldIput.value="+fieldValue);
   
       var fieldClass = row.find(".form_field").attr("class"); 
       cachedRow.find(".field_input").replaceWith("<div class='"+fieldClass + "'>"+fieldValue + "</div>"); 
       cachedDiv.append(cachedRow); 
        
       fields[label] = fieldValue; 

       row = row.next(); 
    }
    var html = "<table class='t_table'>" + cachedDiv.html() + "</table>"; 
    console.log("html="+html); 

    data['html'] = html; 
    data['fields'] = fields; 
    data['template_id'] = templateId; 

    return data; 
}
