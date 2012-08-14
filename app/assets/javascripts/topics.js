$(document).ready(function() {

    $("#topic_templates_select option").live({  
        click : function(){
            console.log("topic_templates_select option clicked"); 
            var container = $(".editor_area"); 
            var templateId = $(".templates_select option:selected").attr("value");
            console.log("templateId=" + templateId);
            
            var url = "/templates/get/" + templateId;
            
            var saveCallback = function(){
                
            }; 


            getTemplate(templateId,container);  
        }

    }); 

})
