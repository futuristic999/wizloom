class TopicsController < ApplicationController
 
  helper_method :saveEntry
   
  def index

  
  end



  def show
    topicId = params[:id]
    @topic = Topic.find(topicId)
    @subTopics = @topic.sub_topics
    @templates = {}
    templateIds = @topic.template_ids.split(',')
    templateIds.each do |templateId|
        template = Template.find(templateId)
        @templates[templateId] = template.name
    end


  end

end
