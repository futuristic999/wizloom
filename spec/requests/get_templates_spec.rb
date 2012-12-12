require 'spec_helper'

describe "GetTemplates" do
  describe "GET /get_templates" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get get_templates_path
      response.status.should be(200)
    end
  end
end
