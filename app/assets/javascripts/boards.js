$(document).ready(function() {

    addNewBlock(); 

     $("#add_block_button").click(function(){
        addNewBlock(); 
     });

     $(".select_block").live({
     
        click: function(event){
            console.log("select_block clicked.");  
            var blockId = $(".select_block option:selected").attr("value");
            var selected = $(this).find('option').filter(":selected"); 
            console.log("selected="+selected.html()); 
            blockId = selected.attr("id"); 
            console.log("select_block clicked, selected=" + blockId);
            var blockContainer = $(this).parents('.block_container'); 
            console.log('blockContainer='+blockContainer.html()); 
            blockContainer.attr('id', blockId); 

            $.ajax({
                url: "/blocks/get/"+blockId,
                type: "GET",
                success: function(data) {
                    console.log("Ajax success, data="+data);
               
                    blockContainer.find(".preview_content").html(data["blockHtml"]); 
                                                                                                                                                            }
            }); 
        }
     });
     
     $(".add_new_block_button").live({
         click: function(event) {
             event.preventDefault();
            console.log("add_new_block_button clicked"); 
            addNewBlock();             

         }
     }); 

    $("#save_board_button").click(function(){
        console.log("save_block_button clicked."); 
        var blocks; 
        var blockContainer = $("#add_blocks_container").find(".block_container:first"); 
        var i = 0; 
        console.log("blockContainer="+blockContainer.html()); 
        
    }); 
});


function addNewBlock(){
   var addBlocksContainer = $("#blocks_design_container");
       
   var blockContainer = $("#_block_container").clone(); 
   blockContainer.attr("id", "0");
                   
   blockContainer.css("display", "block");
   addBlocksContainer.append(blockContainer);  
    
}
