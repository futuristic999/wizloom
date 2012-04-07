class AddSpecialFieldTables < ActiveRecord::Migration
  def change
    create_table :urls do |t|
       t.string  :name
       t.string  :location
       t.string  :description
       t.string  :tags
       t.string  :keyword
       t.integer :user_id
    end

    create_table :tasks do |t|
       t.string  :title
       t.integer  :location_id
       t.datetime    :starts
       t.datetime    :ends
       t.date    :due_date
       t.datetime    :due_time
       t.string  :status
       t.string  :repeat_pattern
       t.boolean :alert
       t.integer :user_id
       t.integer :owner_id       
    end

    create_table :locations do |t|
       t.string  :address
       t.string  :street_number
       t.string  :street
       t.string  :city
       t.string  :state
       t.integer :zipcode
    end

    create_table :comments do |t|
       t.string :body
       t.integer :user_id
       t.timestamps
    end

  end

  def down
  end
end
