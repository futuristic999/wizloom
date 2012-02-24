require 'spec_helper'

describe EntriesController do

  describe "GET 'add'" do
    it "should be successful" do
      get 'add'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

end
