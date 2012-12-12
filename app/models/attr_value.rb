class AttrValue < ActiveRecord::Base
    belongs_to :entry, :foreign_key => "entry_id", :class_name => "Entry"
    belongs_to :attr, :foreign_key => "attr_id", :class_name => "Attr"
end
