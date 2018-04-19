require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do
    assign(:tasks, [
      Task.create!(valid_attributes),
      Task.create!(valid_attributes)
    ])
  end

  let(:valid_attributes) {{
    user_id: 1,
    title:'Test title',
    description:'Test description',
    status:1,
    priority:2,
    due_date:2.days.since,
    start_date:1.day.ago,
    finished_date:Time.current
  }}

  it "renders a list of tasks" do
    render
  end
end
