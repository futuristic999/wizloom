$(document).ready(function() {



     
     $(".new_list_entry").live({
         click: function(event) {
            event.preventDefault();
            console.log("new_list_entry clicked"); 
            var id = $(event.target).attr("id"); 
            console.log("id="+id); 
            
            var tokens = id.split(" "); 
            var viewType = tokens[0]; 
            tokens = tokens[1].split("_"); 
            var blockId = tokens[0]; 
            console.log('viewType='+viewType); 
            console.log('blockId='+blockId); 
            var templateId = tokens[1]; 
            var associatedEntryId = 0; 
            if (tokens.length > 2) {
                associatedEntryId = tokens[2]; 
            }
            console.log('templateId='+templateId+", associatedEntryId="+associatedEntryId); 

            var blockContainer = $(this).parents('.block_container'); 
            //console.log("blockContainer="+blockContainer.html()); 
            /*
            var templateId = blockContainer.attr("id"); 
            console.log("templateId="+templateId); 
          
            var blockId = blockContainer.attr('id'); 
            console.log('blockId='+blockId); 
            */    
            showTemplate(templateId, $("#editor_wrapper")); 
            blockContainer.find('.block_actions_bottom').css('display', 'block'); 
            //var saveButton = $("<div id="+blockId+" class='save_entry_to_list_button save_button'>Save</div>"); 
            //blockContainer.append(saveButton); 
         }
     }); 


     $(".save_entry_to_list_button").live({
        click: function(event) {
            console.log("save_entry_to_list_button clicked"); 
            var blockId = $(event.target).attr("id"); 
            console.log("blockId="+blockId); 
            var data = processHtml();
             
            $.ajax({
                url: '/blocks/handle/'+blockId+'/add',
                type: 'POST', 
                data: data,
                success: function(data){
                    console.log("Ajax success!");
                    var blockHtml = data['blockHtml']; 
                    var newBlockContent = $(blockHtml);   
                    $("#block_container_"+blockId).replaceWith(newBlockContent);                 
                   // var saveButton = $("<div id="+blockId+" class='save_entry_to_list_button save_button'>Save</div>");
                    //blockContainer.append(saveButton);

                }
                
            })
        }
     }); 

    $(".save_entry_button").live({
        click: function(event) {
            console.log("save_entry_button clicked."); 
            var blockId = $(event.target).attr("id"); 
            console.log("blockId="+blockId);
            var data = processHtml(); 
            
            $.ajax({
                url: '/blocks/handle/' + blockId + '/add', 
                type: 'POST', 
                data: data,
                success: function(data){
                    console.log('Ajax success for save_entry_button'); 
                    var blockHtml = data['blockHtml']; 
                    var newBlockContent = $(blockHtml); 
                    $("#block_container_"+blockId).replaceWith(newBlockContent);                    
                }

            })

    
        }
    }); 


});


