  
   
    //show a template in the specified container
    function getTemplate(templateId,container) {
        console.log("In application.js getTemplate");
        var url = "/templates/get/"+ templateId;
        
        $.ajax({
            url : url,
            type: "GET",
            success: function(data) {
                console.log("success in Ajax getTemplate"); 
                console.log(data); 
                var template_html = data['html'];
                var oldTemplate = $(container).find('.template_container'); 
                console.log('oldTemplate=' + oldTemplate);
                oldTemplate.remove();    
               
                container.append(template_html); 
            }

        })
    }
   
   /* 
    
    function saveEntry(data, callback) {
  
        console.log("In application.saveEntry(), data=" + data); 
        var templateId = data['template_id']; 
        var entryId = data['entry_id']; 
        var url = data['url']; 

        $.ajax({
            url : url,
            type : "POST", 
            data : data, 
            success: callback

        });     

    }
    */
