class FieldValue < ActiveRecord::Base
  belongs_to :entry
  belongs_to :field
  has_many :field_metadata, :class_name=>'FieldMetadata', :foreign_key=>'fieldvalue_id'


  def metadata
    mdHash = Hash.new
    field_metadata.each do |md|
      mdHash[md.key.to_sym] = md.value
    end
    return mdHash
  end

end
