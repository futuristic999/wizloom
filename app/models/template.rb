class Template < ActiveRecord::Base
    validates :name, :presence => true
    
    #TODO: phase out fields
    has_many :fields, :order => "display_order ASC"

    has_many :template_data_keys, 
             :foreign_key => :template_id, 
             :class_name => "TemplateDataKey"

    has_many :data_keys, 
             :through => :template_data_keys,
             :order=>"display_order ASC"
    
    

end
