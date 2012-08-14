class TopicEntry < ActiveRecord::Base
    belongs_to :Topic, :foreign_key => "topic_id", :class_name => "Topic"
    belongs_to :Entry, :foreign_key => "entry_id", :class_name => "Entry"
end
