require 'rails_helper'

RSpec.describe "tests/show", type: :view do
  before(:each) do
    @test = assign(:test, Test.create!(
      :title => "Title",
      :text => "MyText",
      :number => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
