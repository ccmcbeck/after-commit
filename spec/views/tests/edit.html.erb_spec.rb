require 'rails_helper'

RSpec.describe "tests/edit", type: :view do
  before(:each) do
    @test = assign(:test, Test.create!(
      :title => "MyString",
      :text => "MyText",
      :number => 1
    ))
  end

  it "renders the edit test form" do
    render

    assert_select "form[action=?][method=?]", test_path(@test), "post" do

      assert_select "input#test_title[name=?]", "test[title]"

      assert_select "textarea#test_text[name=?]", "test[text]"

      assert_select "input#test_number[name=?]", "test[number]"
    end
  end
end
