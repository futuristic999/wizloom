class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.integer :creator
      t.text :xml
      t.text :html
      t.text :theme
      t.boolean :refresh_html
      t.string :status
      t.time :created
      t.time :modified

      t.timestamps
    end
  end
end
