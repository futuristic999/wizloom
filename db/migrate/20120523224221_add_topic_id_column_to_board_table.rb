class AddTopicIdColumnToBoardTable < ActiveRecord::Migration
  def change
    add_column :boards, :topic_id, :integer
  end
end
