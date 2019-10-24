# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  it 'testing of tasks/' do
    @user = User.create!(name: "user1", login_id: "id1", password_digest: "password1")
    @task = Task.create!(name: "task1", description: "this is a task1", "user_id": @user.id, priority: 0, status: 0)
    @task = Task.create!(name: "task2", description: "this is a task2", "user_id": @user.id, priority: 1, status: 1)
    @task = Task.create!(name: "task3", description: "this is a task3", "user_id": @user.id, priority: 2, status: 2)
    
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


  it 'testing of tasks/new' do
    @user = User.create!(name: "user1", login_id: "id1", password_digest: "password1")

    visit new_task_path
    fill_in 'task_name', with: 'task1'
    fill_in 'task_description', with: 'this is a task1'
    fill_in 'task_user_id', with: @user.id
    select 'medium', from: 'task_priority'
    select 'in_progress', from: 'task_status'
    click_button 'Create Task'

    expect(page).to have_content 'Task was successfully created!'
    expect(page).to have_content 'task1'
    expect(page).to have_content 'this is a task1'
    expect(page).to have_content 'medium'
    expect(page).to have_content 'in_progress'
  end

  it 'testing of tasks/show' do
    @user = User.create!(name: "user1", login_id: "id1", password_digest: "password1")
    @task = Task.create!(name: "task1", description: "this is a task1", "user_id": @user.id, priority: 1, status: 1)
    
    visit task_path(@task)
    expect(page).to have_content 'task1'
    expect(page).to have_content 'this is a task1'
    expect(page).to have_content 'medium'
    expect(page).to have_content 'in_progress'
  end

  it 'testing of tasks/edit' do
    @user = User.create!(name: "user1", login_id: "id1", password_digest: "password1")
    @task = Task.create!(name: "task1", description: "this is a task1", "user_id": @user.id, priority: 1, status: 1)
    
    visit edit_task_path(@task)
    expect(page).to have_field 'task_name', with: 'task1'
    expect(page).to have_field 'task_description', with: 'this is a task1'
    expect(page).to have_field 'task_priority', with: 'medium'
    expect(page).to have_field 'task_status', with: 'in_progress'
    fill_in 'task_name', with: 'task2'
    fill_in 'task_description', with: 'this is a task2'
    fill_in 'task_user_id', with: @user.id
    select 'high', from: 'task_priority'
    select 'done', from: 'task_status'
    click_button 'Update Task'
    
    expect(page).to have_content 'Task was successfully updated!'
    expect(page).to have_content 'task2'
    expect(page).to have_content 'this is a task2'
    expect(page).to have_content 'high'
    expect(page).to have_content 'done'
  end
end
