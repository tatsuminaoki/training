require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    @user = create(:user)
    @task1 = create(:task, created_at: DateTime.now)
    @task2 = create(:task, priority: 1, due_date: DateTime.now + 1, created_at: DateTime.now - 1)
    @task3 = create(:task, priority: 2, due_date: DateTime.now + 2, created_at: DateTime.now - 2)
  end

  context 'When a user opens task list' do
    it 'Success to show the list' do
      visit tasks_path

      expect(page).to have_content @task1.title
      expect(page).to have_content @task1.priority
      expect(page).to have_content @task1.status
      expect(page).to have_content @task1.due_date
      expect(page).to have_content I18n.l(@task1.created_at, format: :default)
      expect(page).to have_link I18n.t('operation.detail'), href: task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.update'), href: edit_task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.remove'), href: task_path(@task1.id)
    end

    it 'Task is sorted by created_at with descending order' do
      visit tasks_path

      title = page.all('.title')
      expect(title[0].text).to eq @task1.title
      expect(title[1].text).to eq @task2.title
      expect(title[2].text).to eq @task3.title
    end

    it 'Success to sort by due date with descending order' do
      visit tasks_path
      click_link 'due_date_desc'

      due_date = page.all('.due_date')
      expect(due_date[0].text).to eq @task3.due_date.strftime("%Y-%m-%d")
      expect(due_date[1].text).to eq @task2.due_date.strftime("%Y-%m-%d")
      expect(due_date[2].text).to eq @task1.due_date.strftime("%Y-%m-%d")
    end

    it 'Success to sort by due date with ascending order' do
      visit tasks_path
      click_link 'due_date_asc'

      due_date = page.all('.due_date')
      expect(due_date[0].text).to eq @task1.due_date.strftime("%Y-%m-%d")
      expect(due_date[1].text).to eq @task2.due_date.strftime("%Y-%m-%d")
      expect(due_date[2].text).to eq @task3.due_date.strftime("%Y-%m-%d")
    end

    it 'Success to sort by created_at with descending order' do
      visit tasks_path
      click_link 'created_at_desc'

      created_at = page.all('.created_at')
      expect(created_at[0].text).to eq @task1.created_at.strftime("%Y-%m-%d %H:%M")
      expect(created_at[1].text).to eq @task2.created_at.strftime("%Y-%m-%d %H:%M")
      expect(created_at[2].text).to eq @task3.created_at.strftime("%Y-%m-%d %H:%M")
    end

    it 'Success to sort by created_at with ascending order' do
      visit tasks_path
      click_link 'created_at_asc'

      created_at = page.all('.created_at')
      expect(created_at[0].text).to eq @task3.created_at.strftime("%Y-%m-%d %H:%M")
      expect(created_at[1].text).to eq @task2.created_at.strftime("%Y-%m-%d %H:%M")
      expect(created_at[2].text).to eq @task1.created_at.strftime("%Y-%m-%d %H:%M")
    end

    it 'Success to sort by priority with descending order' do
      visit tasks_path
      click_link 'priority_desc'

      priority = page.all('.priority')
      expect(priority[0].text).to eq @task3.priority
      expect(priority[1].text).to eq @task2.priority
      expect(priority[2].text).to eq @task1.priority
    end

    it 'Success to sort by priority with ascending order' do
      visit tasks_path
      click_link 'priority_asc'

      priority = page.all('.priority')
      expect(priority[0].text).to eq @task1.priority
      expect(priority[1].text).to eq @task2.priority
      expect(priority[2].text).to eq @task3.priority
    end
  end

  context 'When a user opens task detail page' do
    it 'Success to see the task information' do
      visit task_path(@task1.id)

      expect(page).to have_content @task1.title
      expect(page).to have_content @task1.description
      expect(page).to have_content @task1.priority
      expect(page).to have_content @task1.due_date
      expect(page).to have_link I18n.t('operation.update'), href: edit_task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.remove'), href: task_path(@task1.id)
      expect(page).to have_link sprintf("<< %s", I18n.t('header.list')), href: root_path
    end
  end

  context 'When a user creates a task' do
    it 'Success to create a task' do
      visit new_task_path

      fill_in 'task[title]', with: 'Automation Test Task'
      fill_in 'task[description]', with: 'Please create the automation test for this task.'
      select 'Middle', from: I18n.t('header.priority')
      select 'Open', from: I18n.t('header.status')
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.create.success')
    end

    it 'Fail to create a task because of validation error because title is required' do
      visit new_task_path

      fill_in 'task[description]', with: 'Please create the automation test for this task.'
      select 'Middle', from: I18n.t('header.priority')
      select 'Open', from: I18n.t('header.status')
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.create.fail')
      expect(page).to have_content I18n.t('errors.messages.blank')
    end

    it 'Fail to create a task because of validation error because of length of title' do
      visit new_task_path

      fill_in 'task[title]', with: 'T' * (Task::TITLE_MAX_LENGTH + 1)
      fill_in 'task[description]', with: 'Please create the automation test for this task.'
      select 'Middle', from: I18n.t('header.priority')
      select 'Open', from: I18n.t('header.status')
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.create.fail')
      expect(page).to have_content I18n.t('errors.messages.too_long', count: Task::TITLE_MAX_LENGTH)
    end

    it 'Fail to create a task because of validation error because of length of description' do
      visit new_task_path

      fill_in 'task[title]', with: 'Automation Test Task'
      fill_in 'task[description]', with: 'T' * (Task::DESCRIPTION_MAX_LENGTH + 1)
      select 'Middle', from: I18n.t('header.priority')
      select 'Open', from: I18n.t('header.status')
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.create.fail')
      expect(page).to have_content I18n.t('errors.messages.too_long', count: Task::DESCRIPTION_MAX_LENGTH)
    end
  end

  context 'When a user edits a task' do
    it 'Success to edit a task' do
      visit edit_task_path(@task1.id)

      fill_in 'task[title]', with: 'Change the title'
      fill_in 'task[description]', with: 'I changed the title.'
      select 'High', from: I18n.t('header.priority')
      select 'InProgress', from: I18n.t('header.status')
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.update.success')
    end
  end

  context 'When a user deletes a task' do
    it 'Success to delete a task from list page' do
      visit tasks_path

      click_on I18n.t('operation.remove'), match: :first
      expect(page).to have_content I18n.t('flash.remove.success')
    end

    it 'Success to delete a task from detail page' do
      visit task_path(@task1.id)

      click_on I18n.t('operation.remove')
      expect(page).to have_content I18n.t('flash.remove.success')
    end
  end

  context 'When a user searches by title' do
    let!(:task) { create(:task, title: 'hoge') }

    it 'Find one record' do
      visit tasks_path
      fill_in 'search[title]', with: 'hoge'
      click_on I18n.t('operation.search')

      title = page.all('.title')
      expect(title[0].text).to eq 'hoge'
    end
  end

  context 'When a user searches by status' do
    let!(:task) { create(:task, status: 2) }

    it 'Find one record' do
      visit tasks_path
      choose 'search_status_Closed'
      click_on I18n.t('operation.search')

      status = page.all('.status')
      expect(status[0].text).to eq 'Closed'
    end
  end

  context 'When a usr searches by title and status' do
    let!(:task) { create(:task, title: 'fuga', status: 1) }
    it 'Find one record' do
      visit tasks_path
      fill_in 'search[title]', with: 'fuga'
      choose 'search_status_InProgress'
      click_on I18n.t('operation.search')

      title = page.all('.title')
      expect(title[0].text).to eq 'fuga'
    end
  end
end
