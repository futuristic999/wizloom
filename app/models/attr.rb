class Attr < ActiveRecord::Base
    belongs_to :entity, :foreign_key => "entity_id", :class_name => "Entity"
end
