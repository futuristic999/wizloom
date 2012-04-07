class EntryAssociation < ActiveRecord::Base
    belongs_to :entry, :foreign_key => "entry_id", :class_name => "Entry"
    belongs_to :associated_entry, :foreign_key => "associated_entry_id", :class_name => "Entry"
end
