$(document).ready(function() {

    $("#add_new_button").click(function(event) {
        console.log("add_new_button clicked, event="+event.target.getAttribute("id"));
        console.log("this is "+$(this));
	var inlineStyle = $("#dropdown_item_list").attr("style");
        console.log("inlineStyle="+inlineStyle);
        $("#dropdown_item_list").toggle();     
    });

    $(".dropdown dd ul li a").click(function() {
   	var text = $(this).html();
        console.log("selected text is "+text);	
    });

    $(".add_templated_entry_button").click(function(event) {
 	console.log("add_templated_entry_button clicked!");
    });

});



