class AddTemplateIdToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :template_id, :integer
    add_column :blocks, :entry_id, :integer
  end
end
