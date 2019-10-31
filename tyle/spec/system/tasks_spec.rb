# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }

  describe 'views' do
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
      click_on '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
      page.driver.browser.switch_to.alert.dismiss

      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is a task1'
      expect(page).to have_content 'low'
      expect(page).to have_content 'waiting'

      # click DELETE and OK
      click_on '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content 'task1'
      expect(page).to have_no_content 'this is a task1'
      expect(page).to have_no_content 'low'
      expect(page).to have_no_content 'waiting'
    end
  end

  describe 'ordering by created_at' do
    before do
      Task.create!(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0, created_at: 2.days)
      Task.create!(name: 'task2', description: 'this is a task2', user_id: user.id, priority: 1, status: 1, created_at: 1.day)
      Task.create!(name: 'task3', description: 'this is a task3', user_id: user.id, priority: 2, status: 2, created_at: Time.zone.now)
    end

    it 'tests tasks ordered by created_at with descending order at tasks/' do
      visit tasks_path
      expect(page.all('.task-name').map(&:text)).to eq %w[task3 task2 task1]
    end
  end

  describe 'ordering by priority, status, due' do
    before do
      Task.create!(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0, due: '20200101', created_at: 2.days)
      Task.create!(name: 'task2', description: 'this is a task2', user_id: user.id, priority: 1, status: 1, due: '20200202', created_at: 1.day)
      Task.create!(name: 'task3', description: 'this is a task3', user_id: user.id, priority: 2, status: 2, due: '20200303', created_at: Time.zone.now)
    end

    it 'tests ordering by priority' do
      visit tasks_path
      click_on '優先度'
      sleep 1
      expect(page.all('.task-priority').map(&:text)).to eq %w[low medium high]
    end

    it 'tests ordering by status' do
      visit tasks_path
      click_on '状態'
      sleep 1
      expect(page.all('.task-status').map(&:text)).to eq %w[waiting in_progress done]
    end

    it 'tests ordering by due' do
      visit tasks_path
      click_on '期限'
      sleep 1
      expect(page.all('.task-due').map(&:text)).to eq %W[2020-01-01\ 00:00:00\ +0900 2020-02-02\ 00:00:00\ +0900 2020-03-03\ 00:00:00\ +0900]
    end
  end
end
