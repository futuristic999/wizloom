
class Entity < ActiveRecord::Base
  belongs_to :template, 
            :foreign_key => :template_id,
            :class_name => "Template"
  has_many  :attrs,
            :foreign_key => :entity_id,
            :class_name => "Attr"

=begin
  has_many  :entity_attributes,
            :foreign_key => :entity_id,
            :class_name => "EntityAttribute"

  has_many  :attributes, 
            :through => :entity_attributes
            #:through => 'associations'
            #:association_foreign_key=>'associated_entry_id'
=end

   

end
