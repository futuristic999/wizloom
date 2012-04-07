class Field < ActiveRecord::Base
    belongs_to :template
    belongs_to :list_descriptor
end

