class EntryData < ActiveRecord::Base
  belongs_to :entry
  belongs_to :data_key


end
