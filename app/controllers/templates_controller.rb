require 'erb'

class TemplatesController < ApplicationController

  #GET /templates/
  def index
     render :template => 'templates/index.html.erb'  
  end

  #GET /templates/list
  def list
    @templates = Template.all()
    render :template => 'templates/list.html.erb'
  end


  def show
      @template_name = getTemplate(params[:name])
      puts "template_name= #{@template_name}"
      render :template => "templates/show.html.erb"
  end

  # GET /templates/fitness.json
  def get
    puts "In get..."


    if request.xhr?
        
        @template = Template.find(params[:id])

        render :json => {
                     :template => @template 
                    }
    end
  end


  # GET /templates/add
  # Return the template_design page
  def add
      render :template => "templates/add.html.erb"
  end

  # Save the template
  # Only handles the Ajax call right now
  def save
    puts "params=#{params}"
    if request.xhr?
        puts "Is Ajax call!"
        templateData = params[:template]
        puts "name from templateData=#{templateData[:name]}"
        
        templateName = templateData[:name] 

        fieldsData = templateData[:fields]
        fields = Array.new
        fieldsData.each do |pos,fieldData| 
            field = Field.new(fieldData)
            puts "fieldData=#{fieldData}"
            fields.push(field)
        end


        html = getHtml(templateData[:stub_html], fields)
        
        @template = Template.new(:name => templateName,
                                 :stub => templateData[:stub_html],
                                 :cached_html => html, 
                                 :refresh_html => false,
                                 :creator => 1, 
                                 :status => "ACTIVE", 
                                 :fields => fields)



        @template.save()
                
        templateId = @template.id
        puts "templateId=#{templateId}"

        render :json => {:status => 'OK',
                         :template_id => templateId}

        #template = Template.find(templateId)
        #render :json => {:template => template,
        #                 :html => html
        #                 }

    end
  end

 
  #JSON
  def delete
    @templateId = params[:id]
    @status = Template.delete(@templateId)
    puts "Status is #{@status}"
    render :template => "/templates/delete.html.erb"
  end


  def getHtml(stubHtml, fields)

    _fields = Hash.new
    fields.each do |field|
        key = "LABEL_#{field[:display_order]}"
        _fields[key.to_sym] = getLabelHtml(field[:label])
        key = "INPUT_#{field[:display_order]}"
        _fields[key.to_sym] = getInputHtml(field[:fieldtype])
    end

    html = ERB.new(stubHtml).result(binding)
    return html
  end


  def getLabelHtml(label)
     return "<div class='t_label'>#{label}</div>"
  end

  def getInputHtml(fieldType)
    html = "" 
    if fieldType == 't_text'
        html = "<input class='t_text' type='text'/>"
    elsif fieldType == 't_textarea'
        html = "<textarea class='t_textarea'/>"
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
     html = html + "</div><!--end of template_#{templateId}"
     return html

  end 


  def getTemplate(name)
    puts "In getTemplate, name=#{name}"

    if name == 'fitness'
        return "shared/templates/fitness"
    end
  
    if name == "job"
        return "shared/templates/job"
    end

    template_name = "shared/templates/#{name}"
    return template_name
  end
end
