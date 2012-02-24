class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :label
      t.string :type
      t.string :options
      t.string :default

      t.timestamps
    end
  end
end
