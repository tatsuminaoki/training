require 'rails_helper'

RSpec.describe "tasks/show", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(valid_attributes))
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

  it "renders attributes in <p>" do
    render
  end
end
