class AddFieldMetadataTable < ActiveRecord::Migration
  def change
    create_table :field_metadata do |t|
       t.integer  :fieldvalue_id
       t.string  :key
       t.string  :value
    end


  end

  def down
  end
end
