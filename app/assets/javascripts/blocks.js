$(document).ready(function() {

     $(".block-save-entry-button").live({
        click: function(event) {
            event.preventDefault(); 
            console.log(".block-save-entry-button clicked.");
            var boardContainer = $(".board-container"); 
            var mainBlockId = boardContainer.data("main_block_id");  
            
            console.log("mainBlockId="+mainBlockId); 
            console.log("blockIds=" + boardContainer.data("block_ids")); 
            var blockId = $(this).parents(".block-container").attr("id"); 
            console.log("blockId="+blockId); 
                        
            var url = $(this).attr('href');
            console.log("url="+url); 
             
            var templateContainer = $(this).parents('.template_container'); 
            var data = processHtml(templateContainer); 

            $.ajax({
                url: url,
                data: data,
                type: "POST", 
                success: function(data) {
                    console.log("Ajax success for blocks/handle");

                    var entry_html = data['entry_html']; 
                    var entry_id = data['entry_id']; 
                    var block = data['block']; 
                    

                    blockContainer = $("#block-container-"+block['id']);
                    console.log('blockContainer='+blockContainer); 
                     
                    //blockContainer.replaceWith(data['block_html']); 

                    //templateContainer.find('.t_table').replaceWith(entry_html);
                    
                    if (block["id"] == mainBlockId) {
                        console.log("block " + block["id"] + " is main block");
                        console.log("entry_id="+ entry_id); 
                        window.location.href = "/boards/get/6?mode=display&main_entry_id="+entry_id; 

                        $("#block-container-"+block['id']).data("main_entry_id", entry_id);     
                    } else
                    {
                        blockContainer.replaceWith(data['block_html']);


                    }
                }
            }); 
        }

     }),

     
     $(".add-list-item").live({
         click: function(event) {
            event.preventDefault();
            console.log("add-list-item clicked"); 
            var url = $(event.target).attr("href"); 
            console.log("url="+url);
            
            var mainEntryId = $(".board-container").data("main_entry_id"); 
            console.log("mainEntryId=" + mainEntryId);  
            url = url + "&main_entry_id="+mainEntryId;
             
            var templateContainer = $(this).parents(".block-container-actions").find(".template_container");             
            templateContainer.css("display", "block"); 
            $(this).css('display', 'none'); 
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


});


