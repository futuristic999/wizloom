class EntityAttribute < ActiveRecord::Base
    belongs_to :entity, :foreign_key => "entity_id", :class_name => "Entity"
    belongs_to :attribute, :foreign_key => "attribute_id", :class_name => "Attribute"
end
