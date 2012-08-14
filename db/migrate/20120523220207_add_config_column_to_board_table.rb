class AddConfigColumnToBoardTable < ActiveRecord::Migration
  def change
    add_column :boards, :config, :string
  end
end
