class TopicAssociation < ActiveRecord::Base
    belongs_to :topic, :foreign_key => "topic_id", :class_name => "Topic"
    belongs_to :associated_topic, :foreign_key => "associated_topic_id", :class_name => "Topic"
end
