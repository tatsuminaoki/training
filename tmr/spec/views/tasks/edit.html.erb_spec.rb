require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
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

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do
    end
  end
end
