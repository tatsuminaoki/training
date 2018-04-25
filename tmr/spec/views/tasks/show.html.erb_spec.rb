require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(valid_attributes))
  end

  let(:valid_attributes) {FactoryBot.build(:attributes)}

  it "renders attributes in <p>" do
    render
  end
end
