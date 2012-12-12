class AddBooksTable < ActiveRecord::Migration
  def up
    create_table :books do |t|
        t.string :name
        t.string :book_type
        t.string :topic_ids
        t.string :display
    end
  end

  def down
  end
end
