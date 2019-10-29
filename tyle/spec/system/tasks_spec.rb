# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }
  let!(:task) { Task.create(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0) }
  before do
    Task.create!(name: 'task2', description: 'this is a task2', user_id: user.id, priority: 1, status: 1)
    Task.create!(name: 'task3', description: 'this is a task3', user_id: user.id, priority: 2, status: 2)
  end

  it 'tests /tasks/' do
    visit tasks_path
    expect(page).to have_content 'task1'
    expect(page).to have_content 'low'
    expect(page).to have_content 'waiting'
    expect(page).to have_content 'task2'
    expect(page).to have_content 'medium'
    expect(page).to have_content 'in_progress'
    expect(page).to have_content 'task3'
    expect(page).to have_content 'high'
    expect(page).to have_content 'done'
  end

  it 'tests /tasks/new' do
    visit new_task_path
    fill_in 'task_name', with: 'task1'
    fill_in 'task_description', with: 'this is a task1'
    select 'medium', from: 'task_priority'
    select 'in_progress', from: 'task_status'
    click_button '登録する'

    expect(page).to have_content 'タスクが追加されました！'
    expect(page).to have_content 'task1'
    expect(page).to have_content 'this is a task1'
    expect(page).to have_content 'medium'
    expect(page).to have_content 'in_progress'
  end

  it 'tests /tasks/show' do
    visit task_path(task)
    expect(page).to have_content 'task1'
    expect(page).to have_content 'this is a task1'
    expect(page).to have_content 'low'
    expect(page).to have_content 'waiting'
  end

  it 'tests /tasks/edit' do
    visit edit_task_path(task)
    expect(page).to have_field 'task_name', with: 'task1'
    expect(page).to have_field 'task_description', with: 'this is a task1'
    expect(page).to have_field 'task_priority', with: 'low'
    expect(page).to have_field 'task_status', with: 'waiting'
    fill_in 'task_name', with: 'task2'
    fill_in 'task_description', with: 'this is a task2'
    select 'high', from: 'task_priority'
    select 'done', from: 'task_status'
    click_button '更新する'

    expect(page).to have_content 'タスクが更新されました！'
    expect(page).to have_content 'task2'
    expect(page).to have_content 'this is a task2'
    expect(page).to have_content 'high'
    expect(page).to have_content 'done'
  end

  it 'tests a delete button at /tasks/show' do
    visit tasks_path
    expect(page).to have_content 'task1'
    expect(page).to have_content 'low'
    expect(page).to have_content 'waiting'
    visit task_path(task)

    # click DELETE and Cancel
    click_on 'DELETE'
    expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
    page.driver.browser.switch_to.alert.dismiss

    expect(page).to have_content 'task1'
    expect(page).to have_content 'this is a task1'
    expect(page).to have_content 'low'
    expect(page).to have_content 'waiting'

    # click DELETE and OK
    click_on 'DELETE'
    expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this task?'
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_no_content 'task1'
    expect(page).to have_no_content 'this is a task1'
    expect(page).to have_no_content 'low'
    expect(page).to have_no_content 'waiting'
  end
end
