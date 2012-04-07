
class Entry < ActiveRecord::Base
  has_many :fieldValues,  :dependent => :destroy

  has_many  :entry_associations, 
            :foreign_key => "entry_id",
            :class_name => "EntryAssociation"

  has_many  :associated_entries, 
            :through => :entry_associations
            #:through => 'associations'
            #:association_foreign_key=>'associated_entry_id'
  belongs_to  :template










end
