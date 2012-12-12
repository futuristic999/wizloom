$(document).ready(function() {

    console.log("menu.js");

    $(".quick-add-button").live({
        click: function(event){
            console.log("quick-add-button clicked");
            $("#entry-types-dropdown").dialog();
        }
    }); 

    //When the entry-types-dropdown is clicked
    $("#entry-types > li").live({
        click:function(event){
            console.log("entry-types li is clicked."); 
            var entryTypeId = event.target.id;
            console.log("entryTypeId=" + entryTypeId);
            $("#entry-types-dropdown").dialog("close");

            var options = {
                create      : true,
                entryTypeId : entryTypeId,
                entryId     : 0,
                displayInNewWindow: true
            };

            var templatedEntryEditor = new TemplatedEntryEditor(
                $("#main-edit-area"), options
            )
            templatedEntryEditor.display(); 
        }
    }); 


})

/**
The TemplatedEntryEditor gets the display content for an entry 
and 
**/
function TemplatedEntryEditor(container, options){

    console.log("In TemplatedEntryEditor, container="+container);

    this.entryObj = null; 

    this.options = {
        create      : true,
        displayMode : 'NEW',
        displayInNewWindow: false,
        entryTypeId   : null

    };

    this.container = container;

    this.options = $.extend(this.options, options);
     
    this.display = function(){
        console.log("In disply(), this.options=" + this.options);
        console.log(this.options);
        if (this.options['create'] == true) {
            this.displayNewEntry(this.options['entryTypeId'], this.container);  
        }
    }

    this.displayNewEntry = function(entityId, container){
        console.log("In displayNewEntry, entityId=" + entityId); 
        console.log(this); 
        console.log("container=" + container); 
        var url = "entries/create?entity_id=" + entityId;
        $.ajax({
            url : url, 
            type: "GET",
            success: function(data){
                console.log("In displayNewEntry.success: container=" + container); 
                newEntryCallback(data,container); 
            }
        });
    }

    newEntryCallback = function(data, container) {
        console.log("In newEntryCallback(): data=" +data); 
        console.log(data);
        console.log(container); 
        $(container).html(data["entry"]["html"]); 
    }
}
