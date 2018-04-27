require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    FactoryBot.create(:user)

    @task = assign(:task, Task.create!(valid_attributes))
    prepare_statuses
    prepare_priorities
  end

  let(:valid_attributes) {FactoryBot.build(:task_attributes)}

  it "renders attributes in <p>" do
    render
  end
end
