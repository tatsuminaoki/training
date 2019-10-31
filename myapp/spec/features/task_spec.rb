require 'rails_helper'

RSpec.feature "Task management", type: :feature do
  scenario "User creates a new task" do
    visit "/tasks/new"

    fill_in "Name", :with => "My Task"
    fill_in "Description", :with => "Description"
    click_button "Create Task"

    expect(page).to have_text("A new task created!")
  end

  scenario "User edits a task." do
    name = 'mytask-spec'
    task = Task.create(:name => name, :description => 'tmp')
    visit "/tasks/#{task.id}/edit"

    # check if in the right place.
    expect(page).to have_selector("input[value=#{name}]")

    name_edited = 'mytask-spec-edited'
    fill_in "Name", :with => name_edited
    click_button "Update Task"

    # check if updates successfully.
    expect(page).to have_text("Task updated!")
  end

  scenario "User delete a task on detail page." do
    name = 'task-to-delete'
    task = Task.create(:name => name, :description => 'tmp')
    visit "/tasks/#{task.id}"

    click_link "Destroy"

    expect(page).to have_text("Task deleted!")
  end

  scenario "User lists tasks" do
    name = 'task-to-list'
    task = Task.create(:name => name, :description => 'tmp')
    visit "/"

    expect(page).to have_text("task-to-list")
  end
end
