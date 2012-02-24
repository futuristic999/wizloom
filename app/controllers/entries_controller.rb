class EntriesController < ApplicationController

  def index
    @templates = Template.all()
    render :template => "/entries/index.html.erb"
  end


  # Save an entry
  # Only handles the Ajax call right now
  def save
    puts "params=#{params}"
    if request.xhr?


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



        @entry.save()
                
        entryId = @entry.id
        puts "entryId=#{entryId}"

        render :json => {:status => 'OK',
                         :entry => @entry}


    end
  end

 
  def get
    entryId = params[:id]
    @entry = Entry.find(entryId)
    if request.xhr?
        return :json => {:entry => @entry}
    else
        render :template => "/entries/show.html.erb"
    end
  end


  def list
    @entries = Entry.all
    if request.xhr?
        return :json => {:entries => @entries}
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
