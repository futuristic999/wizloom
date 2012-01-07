require 'spec_helper'

describe "weight_entries/show.html.erb" do
  before(:each) do
    @weight_entry = assign(:weight_entry, stub_model(WeightEntry,
      :weight => 1,
      :unit => "Unit",
      :note => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Unit/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
