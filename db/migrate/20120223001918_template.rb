class Template < ActiveRecord::Migration

 def change
     add_column :templates, :stub, :text
     remove_column :templates, :html
     add_column :templates, :cached_html, :text
 end


end
