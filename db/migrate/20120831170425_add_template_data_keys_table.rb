class AddTemplateDataKeysTable < ActiveRecord::Migration
  def up
    create_table :template_data_keys do |t|
        t.integer :template_id
        t.integer :data_key_id
        t.string  :label
        t.integer :display_order
    end
  end

  def down
  end
end
