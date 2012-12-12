/**
The editor widget
**/

(function ( $ ){
   
    console.log( "In beejii.editor" ); 
 
    baseClasses = "ui-beejii-editor";
    stateClasses = "ui-state-hover ui-state-active"

    $.widget( "ui.beejiieditor", {
        
        options: {
            create      : true,
            displayMode : 'NEW',
            displayInNewWindow: false,
            entryTypeId : null,
            templateSource : null
        }, 

        _editorCache : {
            entry      : {},
            template   : {},
            state      : {},
            editorData : {formData : {}},
        },

        _create: function() {
            var self = this;
            var options = this.options;

            console.log( "beejiieditor._create()" );
            console.log( "this.options=" + this.options["displayMode"] );  
            console.log( "templateSource=" + this.options["templateSource"] ); 
            console.log("this.element=" + this.element);

            self._initEditorCache();
           
            //self._trackTemplateFields();
             
            uiTemplateEditor = $( "<div>Try this</div>" )
                .addClass( baseClasses)
                .html(self._editorCache['entry']['html'])
                .delegate ( ".t-field", "click", $.proxy( this._tFieldClicked, this ) )
                .delegate ( ".t-field", "change", $.proxy( this._tFieldChanged, this ))
                .delegate ( "#save-entry-button", "click", 
                                $.proxy( this._saveEntryButtonClicked, this ))
            console.log( "uiTemplateEditor = " + uiTemplateEditor ); 
            uiTemplateEditor.appendTo( self.element );

        },

        //Respond to changes to the options
        _setOption: function(key, value) {
            console.log( "In _setOptions(), keys=" + key + ", value=" + value); 
            switch( key ) {
                case "clear" : 
                    // handle changes to clear option
                    break;
            }
            //In jQuery UI 1.8, you have to manullay invoke the
            //_setOption method from the base Widget
            $.Widget.prototype._setOption.apply( this, arguments ); 
            //In jQuery UI 1.9 and above, you use the _super method instead
            this._super( "_setOption", key, value); 
        }, 

        //clean up any modifications your widget has made to the DOM
        destory: function() {
            // In jQuery UI 1.8, you must invoke the desroy method 
            $.Widget.prototype.destroy.call( this ); 
        
        },

        //Initialize the object cache
        _initEditorCache: function() {
            console.log( "In _initEditorCache" );
            console.log( "this.options = ");
            console.log( this.options );
            var self = this;

            var options = this.options;

            var templateSource = options["templateSource"];

            if (templateSource) { 
                getEntryData(templateSource, 'JSON', this, this._refreshEntryData);
            }
            console.log( "self._editorCache['property'] = " + self._editorCache["templateProperties"]); 
        },

        _refreshEntryData: function(self, data) {
            console.log( "In _refreshEntryData(), data= " );
            console.log( data ); 
            self._editorCache["entry"] = data["entry"];
            console.log( "self._editorCache['entry'] = " ); 
            console.log( self._editorCache["entry"] ); 

            self._editorCache["template"]["properties"] = data["entry"]["properties"]; 
    
            self._populateFieldData( self, data["entry"]["attr_values"] ); 
        },

        _populateFieldData: function( self, entryAttrValues ) {
            console.log( "In _populateFieldData (), entryAttrValues= " ); 
            console.log(entryAttrValues); 

            formData = {}

            $.each( entryAttrValues, function(attrValueId, attrValue) {
                console.log( "attrValue=" ); 
                console.log( attrValue );
                var fieldId = "t-field-" + attrValue["attr_id"] + "-";
                if (attrValue["id"] == null){
                    fieldId += 0;
                }else{
                    fieldId += attrValue["id"]; 
                }
                console.log("----- fieldId=" + fieldId);  
                var fieldValue = attrValue["value"];
                formData[fieldId] = fieldValue; 
            })

            self._editorCache[ "formData" ] = formData;
        },

        _tFieldClicked: function(event) {
            //console.log( "In tFieldClicked" );
            console.log( $(event.target) );
        },

        _tFieldChanged: function(event) {
            console.log( "in t_FieldChanged" ); 
            console.log( $(event.target) );
            var tField = $( event.currentTarget );
            var fieldInput = $( event.target );
            var fieldId = tField.attr( "id" );
            console.log( "fieldId=" + fieldId+", fieldInput.val() = " + fieldInput.val() );
            console.log( fieldInput ); 
            console.log( event );
            this._editorCache["formData"][fieldId] = fieldInput.val();
        },

        _saveEntryButtonClicked: function(event) {
            console.log( "saveEntryButtonCicked ");
            var entry = this._editorCache["entry"]
            //entryAttrValues = ["attr_values"]; 

            //$.each( entryAttrValues, function(attrValueId, attrValue) {
                //var fieldId = "t-field-" + attrValue["attr_id"] + "-" + attrValue["id"] == null ? 0 : attrValue["id"];
                //var fieldValue = attrValue["value"];
                
            //})
            
            var formData = this._editorCache["formData"];
            var entry = this._editorCache["entry"];
            console.log( "formData: ");
            console.log( formData );
            console.log( "entry" );
            console.log( entry );

            var data = {};
            var attrValues = {};
            
            data["properties"] = fromData;  
            var entryId = entry["id"];
            console.log( "entryId=" + entryId);

            var _saveEntryCallback = function(data) {
                console.log( "In _saveEntryCallback(), data=" );
                console.log( data );
            }
            saveEntry(entry, formData, _saveEntryCallback);
        },

        _trackTemplateFields: function() {
            console.log( "In _trackTemplateFields()" );
            var self = this;
            var templateProperties = self._editorCache["template"]["properties"]; 
            console.log( "templateProperties = " + templateProperties );
            for (propertyId in templateProperties) {
                console.log( "propertyId = " + propertyId );
                var field = $( "#t-field-" + propertyId);                
                                
                
            }
        },

        _saveEntryData: function() {
            console.log( "In _saveEntryData" );
            var self = this;
            var formData = self._editorCache["formData"];
            console.log( "formData:" );
            console.log( formData);
        },

        _refreshEditorData: function(key, data) {
            console.log( "_refreshEditorData(), data=" + data); 

            this._editorCache[key] = data;
        },


    });


    function getEntryData(url, format, context, callback) {
        console.log( "In getEntryData" );

        var xhr = $.ajax({
            url   : url,
            type  : "GET",
            async : false,
            success : function( data, status ) {
                console.log( "getEntryData Ajax success, data" );
                callback(context, data);
            },
            error : function() {
                console.log( "Error in getEntryData ajax request" ); 
            }
        }); 

    }

    function saveEntry(data, callback) {
        console.log( "In saveEntry()" );

        var url = "/entries/save"

        var xhr = $.ajax({
            url     :url,
            type    : "POST",
            data    : data,
            success : function( data, status) {
                console.log( "saveEntry success, data: ");
                console.log( data );
                callback( data);
            },
            error  : function() {
                console.log( "Error in saveEntry ajax" );
            }

        });
    }
} ( jQuery ) ); 



