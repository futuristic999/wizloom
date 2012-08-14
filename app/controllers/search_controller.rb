class SearchController < ApplicationController
 
   
  def index
    puts "In SearchController.index"
    @result = [
        {:label=>"Recent Entries",:value=>"RECENT"},
        {:label=>"All Entries", :value=>"ALL"}
    ]; 


    @allEntries = Entry.order("created_at DESC").all
    @allEntries.each do |entry|
        @result.push({:label=>entry.title != nil ? entry.title : 'No Title', :value=>entry.id})
    end

    render :json => @result 
  end






end
