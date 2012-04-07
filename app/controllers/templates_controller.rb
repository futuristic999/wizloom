require 'erb'

class TemplatesController < ApplicationController

  helper ApplicationHelper

  #GET /templates/
  def index
     render :template => 'templates/index.html.erb'  
  end

  #GET /templates/list
  def list
    @templates = Template.all()
    
    if request.xhr?
        render :json => {
                        :templates => @templates
        }
    else
        render :template => 'templates/list.html.erb'
    end
  end



  def show
      @template_name = getTemplate(params[:name])
      puts "template_name= #{@template_name}"
      render :template => "templates/show.html.erb", 
             :locals => { :templateName => "Enter a Name", 
                          :templateHtml=>"<table class='t_table'>", 
                         }
  end

  # GET /templates/fitness.json
  def get
    puts "In get..."


    @template = Template.find(params[:id])
    fields = @template.fields.includes(:list_descriptor)

    listFields = @template.fields.where(:fieldtype=>'t_list')
    listFields.each do |listField|
      listItemType = listField[:list_item_type]
      if listItemType == 'Entry'
         #listItems = getListItems(
      else
          fieldType = listField[:list_item_descriptor]  
      end 

    end

    @fieldValues = Hash.new
    @mode = 'input'

    if request.xhr?
        

        #html = getHtml("#{Rails.root}/app/views/templates/table_format.html.erb", fields)
        #@template[:cached_html] = html
=begin
        render :json => {
                     :template => @template 
                    }
=end        
        render :template => "templates/table_format.html.erb",
               :layout => false
    else 
        render :template=> "templates/table_format.html.erb"
        
    end
  end


  # GET /templates/add
  # Return the template_design page
  def add
      @template = {:name=>'Enter a Name', :cached_html => "<table class='t_table'></table>" }

      render :template => "templates/add.html.erb", 
            :locals => { :templateName => "Enter a Name", :templateHtml=>"<table class='t_table'>"}
  end




  # Save the template
  # Only handles the Ajax call right now
  def save
    puts "params=#{params}"
    if request.xhr?
        templateData = params[:template]
        puts "name from templateData=#{templateData[:name]}"

        templateId = templateData[:id]

        
        templateName = templateData[:name] 

        fieldsData = templateData[:fields]



        if templateId == '0'  
            @template = Template.new
        else
            @template = Template.find(templateId)
            #@template.fields.destroy_all

        end

        fields = @template.fields
        
        fieldsData.each do |pos, fieldData|
            
           if fieldData[:id] == '0'
                puts "fieldData[:id]==0" 
                fieldData.delete(:id)
                listDescriptor = fieldData[:list_descriptor]
                puts "list_descriptor=#{listDescriptor}" 
                fieldData.delete(:list_descriptor)

                field = Field.new(fieldData)
                if listDescriptor.empty? == false
                    field.list_descriptor = ListDescriptor.new(:attributes=>listDescriptor)
                end
                puts "field.id=#{field.id}"
                
                fields.push(field)
           else 
                field = Field.find(fieldData[:id])
                puts "field=#{field}"
                field = field.update_attributes(fieldData)
           end
      
        end

    
        @template.name = templateData[:name]
        @template.stub = templateData[:stub_html]
        @template.creator = 1
        @template.status = "ACTIVE"
        

        @template.fields = fields
        puts "Before save, fields=#{@template.fields}"

        result = @template.save()
        puts "Ater save, result=#{result}, template.id=#{@template.id}"
       
        @template = Template.find(@template.id) 
         
        #Now the fields have ids 
        fields = @template.fields
        puts "After save, fields=#{fields}"
        
                
        #html = getHtml(templateData[:stub_html], fields)
        #@template.cached_html = html
        
        @template.refresh_html = true


        @template.save()

        templateId = @template.id
        puts "templateId=#{templateId}"

        render :json => {:status => 'OK',
                         :template_id => templateId}


    end
  end

  def edit
    templateId = params[:id]
    @template = Template.find(templateId)
    @fields = @template.fields
    render :template => "/templates/edit.html.erb"

  end
  
   
  #JSON
  def delete
    @templateId = params[:id]
    @status = Template.delete(@templateId)
    puts "Status is #{@status}"
    render :template => "/templates/delete.html.erb"
  end


  def getHtml(templateName, fields) 
     html = ERB.new(File.new(templateName).read).result(binding)
     return html
  end

  def getHtmlOld(stubHtml, fields)

    _fields = Hash.new
    fields.each do |field|
        key = "LABEL_#{field[:display_order]}"
        _fields[key.to_sym] = getLabelHtml(field[:label])
        key = "INPUT_#{field[:display_order]}"
        _fields[key.to_sym] = getInputHtml(field)
        key = "ID_#{field[:display_order]}"
        _fields[key.to_sym] = field[:id]
    end

    puts "In getHtml, _fields=#{_fields}"

    stubHtml = CGI.unescapeHTML(stubHtml)
    puts "stubHtml=#{stubHtml}" 

    html = ERB.new(stubHtml).result(binding)
    puts "@@@@@ html=#{html}"
    return html
  end


  def getLabelHtml(label)
     return "#{label}"
  end

  def getInputHtml(field)
    html = "" 
    fieldType = field[:fieldtype]
    if fieldType == 't_text'
        html = "<input class='form_field t_text' type='text'></input>"
    elsif fieldType == 't_textarea'
        html = "<textarea class='form_field t_textarea'></textarea>"
    elsif fieldType == 't_url'
        html = "<input class='form_field t_url' type='text'></input>"
    elsif fieldType == 't_location'
        html = "<input class='form_field t_location' type='text'></input>"
    elsif fieldType == 't_autolist_select'
        selectOptions = getAutoSelectOptions(field[:auto_list_id]); 
        html = "<select class='form_field t_autolist_select'>"+
                selectOptions + 
                "</select>"
    elsif fieldType == 't_list'
        listItemType = field[:list_item_type] 
        listItemDescriptor =   field[:list_item_descriptor] 
        html = "<div class='t_list_actions'>" + 
                   "<a href='' id='add_list_item_#{listItemType}_#{listItemDescriptor}' class='add_list_item'>Add to List</a>"+
                "</div>" + 
                "<div class='t_list_items'>" +
                    "<div id='t_list_item_#{listItemType}_#{listItemDescriptor}_0' class='t_list_item'>" + 
                        getInputHtml({:fieldtype=>listItemDescriptor}) +  
                    "</div>" + 
                "</div>" + 
                "<div class='t_list_actions'>"+ 
                    "<a href='#' id='save_list_item_#{listItemType}_#{listItemDescriptor}' class='save_list_item'>Save</a>"+
                "</div>"

    end
    return html
  end

  def getAutoSelectOptions(autoSelectId)
    puts "In getAutoSelectOptions...autoSelectId=#{autoSelectId}"
    html = ""
    entries = Entry.includes(:fieldValues).where(:template_id=>autoSelectId)
    entries.each do |entry|
        fieldValues = entry.fieldValues
        fieldValues.each do |fieldValue|
            if fieldValue[:label] == 'Name'
                html = "#{html}<option value=#{entry[:id]}> #{fieldValue[:value]}</option>"
            end
        end
    end

    return html 
  end

  def Html(templateId)
     html = "<div id='template_"+templateId + "' class='template_form'>"; 
     template = Template.find(templateId)
     fields = template.fields
     fields.each {|field|
         puts "FIELD is   #{field}"
         html += "<div class='t_label'>#{field.label}</div>"
         
         html += "<div class='t_field'>"

         if field.fieldtype == "t_text"
            html += "<input class='t_text' id='#{field.id}' type='text'>"
         elsif field.fieldtype == "t_textarea"
            html += "<textarea class='t_textarea' id='#{field.id}'>"
         end
     }
     html = html + "</div>"
     return html

  end 

end
