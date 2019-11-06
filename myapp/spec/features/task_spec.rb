require 'rails_helper'

RSpec.feature "Task management", type: :feature do
  scenario "User creates a new task" do
    visit new_task_path

    fill_in I18n.t('name'), with: "My Task"
    fill_in I18n.t('description'), with: "説明"
    click_button I18n.t('form_submit')

    expect(page).to have_text("#{I18n.t('new_task_created')}")
  end

  scenario "User edits a task." do
    name = 'mytask-spec'
    task = Task.create(name: name, description: 'tmp')
    visit edit_task_path(task)

    # check if in the right place.
    expect(page).to have_selector("input[value=#{name}]")

    name_edited = 'mytask-spec-edited'
    fill_in I18n.t('name'), with: name_edited
    click_button I18n.t('form_submit')

    # check if updates successfully.
    expect(page).to have_text("#{I18n.t('task_updated')}")
    expect(page).to have_text(name_edited)
  end

  scenario "User delete a task on detail page." do
    name = 'task-to-delete'
    task = Task.create(name: name, description: 'tmp')
    visit task_path(task)

    click_link I18n.t('link_delete')

    expect(page).to have_text("#{I18n.t('task_deleted')}")
    expect(page).not_to have_text(name)
  end

  scenario "User lists tasks" do
    name = 'task-to-list'
    task = Task.create(name: name, description: 'tmp')
    visit root_path

    expect(page).to have_text(name)
  end
end
