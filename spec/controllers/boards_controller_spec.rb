require 'spec_helper'

describe BoardsController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'save'" do
    it "should be successful" do
      get 'save'
      response.should be_success
    end
  end

  describe "GET 'delete'" do
    it "should be successful" do
      get 'delete'
      response.should be_success
    end
  end

  describe "GET 'get'" do
    it "should be successful" do
      get 'get'
      response.should be_success
    end
  end

end
