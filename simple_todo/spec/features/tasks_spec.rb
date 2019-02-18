require 'rails_helper'

RSpec.feature "tasks", type: :feature do

  background do
    task = FactoryBot.create(:task)
  end

  scenario "task list" do
    visit tasks_path

    expect(page).to have_content t('contents.index')
    expect(page).to have_content 'test title'
  end

  scenario "task new" do
    visit new_task_path

    fill_in 'Title', with: 'test Title'
    fill_in 'Description', with: 'test Description'
    fill_in 'User', with: '1'
    select '2024', from: 'task_limit_1i'
    select 'December', from: 'task_limit_2i'
    select '29', from: 'task_limit_3i'
    select '22', from: 'task_limit_4i'
    select '59', from: 'task_limit_5i'
    select '5', from: 'task_priority'
    fill_in 'Status', with: '1'

    click_button 'submit'

    expect(page).to have_content 'Task was successfully created.'
  end

  scenario "task add count" do
    visit new_task_path

    expect{
      fill_in 'Title', with: 'test Title'
      fill_in 'Description', with: 'test Description'
      fill_in 'User', with: '1'
      select '2024', from: 'task_limit_1i'
      select 'December', from: 'task_limit_2i'
      select '29', from: 'task_limit_3i'
      select '22', from: 'task_limit_4i'
      select '59', from: 'task_limit_5i'
      select '5', from: 'task_priority'
      fill_in 'Status', with: '1'

      click_button 'Create Task'
    }.to change{Task.count}.by(1)
  end

  scenario "task edit" do
    visit tasks_path
    click_link 'Edit'

    fill_in 'Title', with: 'new Title'
    fill_in 'Description', with: 'new Description'

    click_button 'Update Task'

    expect(page).to have_content 'Task was successfully updated.'
    expect(page).to have_content 'new Title'
  end  

  scenario "task delete" do
    visit tasks_path
    click_link 'Destroy'

    expect(page).to have_content 'Task was successfully destroyed.'
  end

  scenario "task delete count" do
    visit tasks_path
    expect{click_link 'Destroy'}.to change{Task.count}.by(-1)
  end
end