class BlogsController < ApplicationController
 
  helper_method :saveEntry
   
  def index
    @templates = Template.all()
    @entries = Entry.includes(:fieldValues).all 

     fields = Hash.new

    @entries.each do |entry|
        fieldValues = entry.fieldValues.includes(:field, :field_metadata)
        fields[entry.id] = fieldValues

    end
  
  end


end
