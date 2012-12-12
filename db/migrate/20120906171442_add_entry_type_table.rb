class AddEntryTypeTable < ActiveRecord::Migration
  def up
    create_table :entry_types do |t|
        t.string :type_code
        t.string :type_name
        t.integer :default_template_id
        t.string :template_ids
        t.integer :owner_id
    end
  end

  def down
  end
end
