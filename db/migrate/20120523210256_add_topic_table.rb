class AddTopicTable < ActiveRecord::Migration
  def change
   create_table :topics do |t|
      t.integer :id
      t.string  :name
      t.string  :config
      t.integer :template_id
      t.timestamps
   end

   create_table :topic_associations do |t|
       t.integer :topic_id
       t.integer :associated_topic_id
       t.string  :association_type
       t.string  :config
       t.timestamps
   end                                                     
  end

  def down
  end
end
