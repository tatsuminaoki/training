require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    # @TODO step16でユーザ導入したらidは指定しないようにする
    @user = User.create!(id: 1, name: 'test_user', email: 'test@rakuten.com', encrypted_password: '', role: 0)
    @task = Task.create!(title: 'test_task', description: 'This is a test task.', user_id: @user.id, priority: 0, status: 0, due_date: '2019-10-20')
  end

  context 'When a user opens task list' do
    it 'Success to show the list' do
      visit tasks_path

      expect(page).to have_content @task.title
      expect(page).to have_content @task.priority
      expect(page).to have_content @task.status
      expect(page).to have_content @task.due_date
      expect(page).to have_content @task.created_at
      expect(page).to have_link 'Detail', href: task_path(@task.id)
      expect(page).to have_link 'Update', href: edit_task_path(@task.id)
      expect(page).to have_link 'Remove', href: task_path(@task.id)
    end
  end

  context 'When a user opens task detail page' do
    it 'Success to see the task information' do
      visit task_path(@task.id)

      expect(page).to have_content @task.title
      expect(page).to have_content @task.description
      expect(page).to have_content @task.priority
      expect(page).to have_content @task.due_date
      expect(page).to have_link 'Update Task', href: edit_task_path(@task.id)
      expect(page).to have_link 'Remove', href: task_path(@task.id)
      expect(page).to have_link '<< Task List', href: root_path
    end
  end

  context 'When a user creates a task' do
    it 'Success to create a task' do
      visit new_task_path
  
      fill_in 'task[title]', with: 'Automation Test Task'
      fill_in 'task[description]', with: 'Please create the automation test for this task.'
      select 'Middle', from: 'Priority'
      select 'Open', from: 'Status'
      click_on 'commit'
  
      expect(page).to have_content 'Task is successfully created!'
    end

    xit 'Fail to create a task because of validatio error' do
    end
  end

  context 'When a user edits a task' do
    it 'Success to edit a task' do
      visit edit_task_path(@task.id)
  
      fill_in 'task[title]', with: 'Change the title'
      fill_in 'task[description]', with: 'I changed the title.'
      select 'High', from: 'Priority'
      select 'InProgress', from: 'Status'
      click_on 'commit'
      
      expect(page).to have_content 'Task is successfully updated!'
    end

    xit 'Fail to create a task because of validatio error' do
    end
  end

  context 'When a user deletes a task' do
    it 'Success to delete a task from list page' do
      visit tasks_path

      click_on 'Remove'
      expect(page).to have_content 'Task is successfully deleted!'
    end

    it 'Success to delete a task from detail page' do
      visit task_path(@task.id)

      click_on 'Remove'
      expect(page).to have_content 'Task is successfully deleted!'
    end
  end
end
