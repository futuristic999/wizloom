
class Entry < ActiveRecord::Base
  belongs_to :entity 

  has_many   :entry_data, :class_name=>"EntryData",  :dependent => :destroy

  has_many   :attr_values, :class_name=>"AttrValue", :dependent => :destroy

  has_many   :entry_associations, 
             :foreign_key => "entry_id",
             :class_name => "EntryAssociation"

  has_many   :associated_entries, 
             :through => :entry_associations
            #:through => 'associations'
            #:association_foreign_key=>'associated_entry_id'
  belongs_to  :template
 
    before_create :check_entity
    after_initialize  :initialize_attributes

    private

        def check_entity
            puts "self.entity = #{self.entity}"
        end

        def initialize_attributes
            attrs = self.entity.attrs
            attrs.each do |attr| 
                attr_value = AttrValue.new({
                    :attr_id => attr.id,                    
                    :value => attr.default_value
                })
                self.attr_values.push(attr_value)
            end
        end






end
