class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :body
      t.integer :creator
      t.string :status
      t.boolean :refresh_html
      t.references :fieldvalues
      t.references :template

      t.timestamps
    end
    add_index :entries, :fieldvalues_id
    add_index :entries, :template_id
  end
end
