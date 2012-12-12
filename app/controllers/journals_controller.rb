class JournalsController < ApplicationController
 
   
  def index
    @templates = Template.all()
    @entries = Entry.includes(:fieldValues).all 

     fields = Hash.new

    @entries.each do |entry|
        fieldValues = entry.fieldValues.includes(:field, :field_metadata)
        fields[entry.id] = fieldValues

    end
  
  end

  def testExerciseJournal
    template_id = 89
    template = "/journals/sandbox/custom_templates/running_tracker_template.html"

    @template = Template.find(template_id)
    @data_keys = @template.data_keys


    render :template=>"/journals/sandbox/test_journal"
  end

   

end
