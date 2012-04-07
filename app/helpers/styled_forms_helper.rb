module StyledFormsHelper



class LabellingFormBuilder < ActionView::Helpers::FormBuilder
    def text_field(attribute, options={})
        label(attribute) + super
    end
end


end
