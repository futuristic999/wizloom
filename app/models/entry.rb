class Entry < ActiveRecord::Base
  has_many :fieldValues,  :dependent => :destroy
  has_one  :template
end
