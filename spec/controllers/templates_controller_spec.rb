require 'spec_helper'

describe TemplateController do

  describe "GET 'get'" do
    it "should be successful" do
      get 'get'
      response.should be_success
    end
  end

  describe "GET 'add'" do
    it "should be successful" do
      get 'add'
      response.should be_success
    end
  end

end
