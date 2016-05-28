require 'rails_helper'

RSpec.describe "tests/new", type: :view do
  before(:each) do
    assign(:test, Test.new(
      :title => "MyString",
      :text => "MyText",
      :number => 1
    ))
  end

  it "renders new test form" do
    render

    assert_select "form[action=?][method=?]", tests_path, "post" do

      assert_select "input#test_title[name=?]", "test[title]"

      assert_select "textarea#test_text[name=?]", "test[text]"

      assert_select "input#test_number[name=?]", "test[number]"
    end
  end
end
