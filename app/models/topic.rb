class Topic < ActiveRecord::Base

  has_many  :topic_associations, 
            :foreign_key => "topic_id",
            :class_name => "TopicAssociation"

  has_many  :associated_topics, 
            :through => :topic_associations

  has_many  :topic_entries,
            :foreign_key => "topic_id",
            :class_name => "TopicEntry"

  has_many  :entries,
            :through => :topic_entries

  has_many  :feeds

  belongs_to  :template


  def sub_topics
    puts "self.id=#{self.id}"

    return self.associated_topics.where({'topic_associations.association_type'=>'child'})
  end

end
