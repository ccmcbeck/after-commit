require 'rails_helper'

RSpec.describe "tests/index", type: :view do
  before(:each) do
    assign(:tests, [
      Test.create!(
        :title => "Title",
        :text => "MyText",
        :number => 1
      ),
      Test.create!(
        :title => "Title",
        :text => "MyText",
        :number => 1
      )
    ])
  end

  it "renders a list of tests" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
