class Template < ActiveRecord::Base
    validates :name, :presence => true

    has_many :fields, :order => "display_order ASC"

    
    

end
