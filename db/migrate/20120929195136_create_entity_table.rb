class CreateEntityTable < ActiveRecord::Migration
  def up
    create_table :entities do |t|
        t.string  :name
        t.string  :description
        t.integer :template_id
        t.integer :owner_id
    end
  end

  def down
  end
end
