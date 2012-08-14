class AddFeedsTable < ActiveRecord::Migration
  def change
   create_table :feeds do |t|
         t.integer  :id
         t.integer  :topic_id
         t.string   :activity_type
         t.string   :message
         t.timestamps
   end      

  end

  def down
  end
end
