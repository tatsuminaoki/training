require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  scenario "user create a new task" do
    visit root_path
    expect {
      click_link "New Task"
      fill_in "Title", with: "Setup DEV ENV"
      fill_in "Description", with: "Setup development environment on localhost."
      fill_in "User", with: 1
      fill_in "Priority", with: 0
      fill_in "Status", with: 0
      fill_in "Due date", with: "2018-04-17"
      click_button "Create Task"

      expect(page).to have_content "Task was successfully created"
    }.to change(Task, :count).by(1)
  end
end
