class AddUnitColumnToDataKeyTable < ActiveRecord::Migration
  def change
    add_column :data_keys, :unit, :string
  end
end
