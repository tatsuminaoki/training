# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }

  describe 'views' do
    let!(:task) { create(:task, { user_id: user.id }) }
    before do
      create(:task2, { user_id: user.id })
      create(:task3, { user_id: user.id })
    end

    context 'visit tasks_path' do
      subject { visit tasks_path }

      it 'lists the appropriate tasks' do
        subject
        expect(page).to have_content 'task1'
        expect(page).to have_content 'low'
        expect(page).to have_content 'waiting'
        expect(page).to have_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'in_progress'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_content 'task3'
        expect(page).to have_content 'high'
        expect(page).to have_content 'done'
        expect(page).to have_content '2021/01/02'
      end
    end

    context 'visit new_task_path' do
      subject { visit new_task_path }

      it 'enables you to create a new task' do
        subject
        visit new_task_path
        fill_in 'task_name', with: 'task1'
        fill_in 'task_description', with: 'this is a task1'
        fill_in 'task_due', with: Date.current
        select 'medium', from: 'task_priority'
        select 'in_progress', from: 'task_status'
        click_button '登録する'

        expect(page).to have_content 'タスクが追加されました！'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'in_progress'
        expect(page).to have_content Date.current.strftime('%Y/%m/%d')
      end
    end

    context 'visit task_path(task)' do
      subject { visit task_path(task) }

      it 'shows the appropriate task' do
        subject
        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content 'low'
        expect(page).to have_content 'waiting'
        expect(page).to have_content '2020/12/31'
      end

      it 'enables you to delete the task with the delete button' do
        subject
        expect(page).to have_content 'task1'
        expect(page).to have_content 'low'
        expect(page).to have_content 'waiting'
        expect(page).to have_content '2020/12/31'

        # click DELETE and Cancel
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
        page.driver.browser.switch_to.alert.dismiss

        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content 'low'
        expect(page).to have_content 'waiting'
        expect(page).to have_content '2020/12/31'

        # click DELETE and OK
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content 'this is a task1'
        expect(page).to have_no_content 'low'
        expect(page).to have_no_content 'waiting'
        expect(page).to have_no_content '2020/12/31'
      end
    end

    context 'visit edit_task_path(task)' do
      subject { visit edit_task_path(task) }

      it 'tests /tasks/edit' do
        subject
        expect(page).to have_field 'task_name', with: 'task1'
        expect(page).to have_field 'task_description', with: 'this is a task1'
        expect(page).to have_field 'task_priority', with: 'low'
        expect(page).to have_field 'task_status', with: 'waiting'
        fill_in 'task_name', with: 'task2'
        fill_in 'task_description', with: 'this is a task2'
        fill_in 'task_due', with: Date.current
        select 'high', from: 'task_priority'
        select 'done', from: 'task_status'
        click_button '更新する'

        expect(page).to have_content 'タスクが更新されました！'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'this is a task2'
        expect(page).to have_content 'high'
        expect(page).to have_content 'done'
        expect(page).to have_content Date.current.strftime('%Y/%m/%d')
      end
    end
  end

  describe 'ordering' do
    before do
      create(:task, { user_id: user.id, created_at: 2.days })
      create(:task2, { user_id: user.id, created_at: 1.day })
      create(:task3, { user_id: user.id, created_at: Time.zone.now })
    end

    context 'visit tasks_path' do
      subject { visit tasks_path }

      it 'tasks ordered by created_at with descending' do
        subject
        expect(page.all('.task-name').map(&:text)).to eq %w[task3 task2 task1]
      end

      it 'tasks ordered by priority' do
        subject
        click_on '優先度'
        sleep 1
        expect(page.all('.task-priority').map(&:text)).to eq %w[low medium high]
        click_on '優先度'
        sleep 1
        expect(page.all('.task-priority').map(&:text)).to eq %w[high medium low]
      end

      it 'tasks ordered by status' do
        subject
        click_on '状態'
        sleep 1
        expect(page.all('.task-status').map(&:text)).to eq %w[waiting in_progress done]
        click_on '状態'
        sleep 1
        expect(page.all('.task-status').map(&:text)).to eq %w[done in_progress waiting]
      end

      it 'tasks ordered by due' do
        subject
        click_on '期限'
        sleep 1
        expect(page.all('.task-due').map(&:text)).to eq %W[2020/12/31\ 00:00 2021/01/01\ 00:00 2021/01/02\ 00:00]
        click_on '期限'
        sleep 1
        expect(page.all('.task-due').map(&:text)).to eq %W[2021/01/02\ 00:00 2021/01/01\ 00:00 2020/12/31\ 00:00]
      end
    end
  end

  describe 'search' do
    before do
      create(:task, { user_id: user.id, created_at: 2.days })
      create(:task2, { user_id: user.id, created_at: 1.day })
      create(:task3, { user_id: user.id, created_at: Time.zone.now })
    end

    context 'visit tasks_path' do
      subject { visit tasks_path }

      it 'tasks searched by name `task2`' do
        subject
        fill_in 'search_by_name', with: 'task2'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content 'low'
        expect(page).to have_no_content 'waiting'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'in_progress'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content 'high'
        expect(page).to have_no_content 'done'
        expect(page).to have_no_content '2021/01/02'
      end

      it 'tasks searched by priority `Low`' do
        subject
        select 'Low', from: 'search_by_priority'
        click_on '検索'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'low'
        expect(page).to have_content 'waiting'
        expect(page).to have_content '2020/12/31'
        expect(page).to have_no_content 'task2'
        expect(page).to have_no_content 'medium'
        expect(page).to have_no_content 'in_progress'
        expect(page).to have_no_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content 'high'
        expect(page).to have_no_content 'done'
        expect(page).to have_no_content '2021/01/02'
      end

      it 'tasks searched by status `Done`' do
        subject
        select 'Done', from: 'search_by_status'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content 'low'
        expect(page).to have_no_content 'waiting'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_no_content 'task2'
        expect(page).to have_no_content 'medium'
        expect(page).to have_no_content 'in_progress'
        expect(page).to have_no_content '2021/01/01'
        expect(page).to have_content 'task3'
        expect(page).to have_content 'high'
        expect(page).to have_content 'done'
        expect(page).to have_content '2021/01/02'
      end

      it 'tasks searched by name `task`, priority `Medium`, and status `In_progress`' do
        subject
        fill_in 'search_by_name', with: 'task'
        select 'Medium', from: 'search_by_priority'
        select 'In_progress', from: 'search_by_status'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content 'low'
        expect(page).to have_no_content 'waiting'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'in_progress'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content 'high'
        expect(page).to have_no_content 'done'
        expect(page).to have_no_content '2021/01/02'
      end
    end
  end
end
