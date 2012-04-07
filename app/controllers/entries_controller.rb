class EntriesController < ApplicationController

  def index
    @templates = Template.all()
    render :template => "/entries/index.html.erb"
  end


  # Save an entry
  # Only handles the Ajax call right now
  def save
    puts "params=#{params}"
    @entry = saveEntry(params)


=begin
        templateId = params[:template_id];
        template = Template.find(templateId)
         
        title = "#{template.name} Entry"

        cachedHtml = params[:html]; 

        fieldsData = params[:fields]
        fieldValues = Array.new
        fieldsData.each do |label,fieldValue| 
            fieldValue = FieldValue.new({:label=>label, :value=>fieldValue})
            puts "fieldValue=#{fieldValue}"
            fieldValues.push(fieldValue)
        end


        
        @entry = Entry.new(     :template => template,
                                 :title => title,
                                 :body => cachedHtml, 
                                 :refresh_html => false,
                                 :creator => 1, 
                                 :status => "ACTIVE", 
                                 :fieldValues => fieldValues)



        @entry.save()=
=end               
        entryId = @entry.id
        puts "entryId=#{entryId}"
        @template = @entry.template
        @fieldValues = @entry.fieldValues.includes(:field, :field_metadata)
 
        if request.xhr?
           render :template => "/entries/table_format.html.erb",
                  :layout => false
        else
            render :template => "/entries/table_format.html.erb"
        end

  end

 
  def get
    entryId = params[:id]
    @entry = Entry.find(entryId)
    @template = @entry.template
    
      
    @fieldValues = @entry.fieldValues.includes(:field, :field_metadata) 
    #@fieldValues.each do |fieldValue|
       #metadata = fieldValue.metadata
       #puts "metadata=#{metadata}"
    
    #end 
    @mode = 'display'
    if request.xhr?
       render :template => "/entries/table_format.html.erb",
              :layout => false
    else 
        render :template => "/entries/table_format.html.erb"
    end
=begin
    if request.xhr?
        return :json => {:entry => @entry}
    else
        render :template => "/entries/show.html.erb"
    end
=end
  end


  def list

    templateId = params[:template]

    if templateId != nil
        @entries = Entry.includes(:fieldValues).where(:template_id=>templateId)
    else
        @entries = Entry.includes(:fieldValues).all
    end


    fields = Hash.new

    @entries.each do |entry|
        fieldValues = entry.fieldValues
        fields[entry.id] = fieldValues    

    end
     
    if request.xhr?
        render :json => {:entries => @entries, :fieldValues => fields}
    else 
        render :template => "/entries/list.html.erb"
    end
  end


  def delete
    entryId = params[:id]
    status = Entry.delete(entryId)
    if request.xhr?
        puts "It's Ajax delete."
        render :json => {:status => 'OK', :entry_id => entryId }
    end
  end

  def add

  end

  def show
  end

end
