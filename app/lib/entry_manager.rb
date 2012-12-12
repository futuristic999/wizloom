class EntryManager    

  def self.initialize_entry(entity)

      entry = Entry.new
      entry.entity_id = entity.id

      entity.attributes.each do |attribute|
        attr_value = AttributeValue.new({
            :attribute_id => attribute.id,
            :value => attribute.default_value
        })
        entry.attribute_values.push(attr_value)
      end

      return entry

   end

end
