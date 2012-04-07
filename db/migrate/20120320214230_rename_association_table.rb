class RenameAssociationTable < ActiveRecord::Migration
  def up
    drop_table :associations
    
    create_table :entry_associations do |t|
         t.integer :entry_id
         t.integer :associated_entry_id
         t.integer :list_id
         t.string :association_type
         t.integer :display_order
     end
  end


  def down
  end
end
