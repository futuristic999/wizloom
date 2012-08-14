class AddTemplateIdsToTopicTable < ActiveRecord::Migration
  def change
    add_column :topics, :template_ids, :string
  end


end
