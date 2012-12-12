class TemplateDataKey < ActiveRecord::Base
    belongs_to :template, :foreign_key => "template_id", :class_name => "Template"
    belongs_to :data_key, :foreign_key => "data_key_id", :class_name => "DataKey"
end
