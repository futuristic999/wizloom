require 'spec_helper'

describe "weight_entries/index.html.erb" do
  before(:each) do
    assign(:weight_entries, [
      stub_model(WeightEntry,
        :weight => 1,
        :unit => "Unit",
        :note => "MyText"
      ),
      stub_model(WeightEntry,
        :weight => 1,
        :unit => "Unit",
        :note => "MyText"
      )
    ])
  end

  it "renders a list of weight_entries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Unit".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
