class BlogsController < ApplicationController
 
   
  def index
      filter = {}
      entries = get_entries(:filter=>filter)
      entry_types = get_entry_types(:filter=>filter) 
  end


end
