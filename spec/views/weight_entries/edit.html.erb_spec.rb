require 'spec_helper'

describe "weight_entries/edit.html.erb" do
  before(:each) do
    @weight_entry = assign(:weight_entry, stub_model(WeightEntry,
      :weight => 1,
      :unit => "MyString",
      :note => "MyText"
    ))
  end

  it "renders the edit weight_entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => weight_entries_path(@weight_entry), :method => "post" do
      assert_select "input#weight_entry_weight", :name => "weight_entry[weight]"
      assert_select "input#weight_entry_unit", :name => "weight_entry[unit]"
      assert_select "textarea#weight_entry_note", :name => "weight_entry[note]"
    end
  end
end
