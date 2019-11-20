# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }

  # login
  before do
    visit login_path
    fill_in 'session_login_id', with: user.login_id
    fill_in 'session_password', with: 'password1'
    click_on 'ログイン'
    expect(page).to have_content 'ログアウト'
  end

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
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_content 'task3'
        expect(page).to have_content '高'
        expect(page).to have_content '完了'
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
        select '中', from: 'task_priority'
        select '実施中', from: 'task_status'
        click_button '登録する'

        expect(page).to have_content 'タスクが追加されました！'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content Date.current.strftime('%Y/%m/%d')
      end
    end

    context 'visit task_path(task)' do
      subject { visit task_path(task) }

      it 'shows the appropriate task' do
        subject
        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'
      end

      it 'enables you to delete the task with the delete button' do
        subject
        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        # click DELETE and Cancel
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
        page.driver.browser.switch_to.alert.dismiss

        expect(page).to have_content 'task1'
        expect(page).to have_content 'this is a task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        # click DELETE and OK
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にタスクを削除してもいいですか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content 'this is a task1'
        expect(page).to have_no_content '2020/12/31'
      end
    end

    context 'visit edit_task_path(task)' do
      subject { visit edit_task_path(task) }

      it 'tests /tasks/edit' do
        subject
        expect(page).to have_field 'task_name', with: 'task1'
        expect(page).to have_field 'task_description', with: 'this is a task1'
        expect(page).to have_field 'task_priority', with: 0
        expect(page).to have_field 'task_status', with: 0
        fill_in 'task_name', with: 'task2'
        fill_in 'task_description', with: 'this is a task2'
        fill_in 'task_due', with: Date.current
        select '高', from: 'task_priority'
        select '完了', from: 'task_status'
        click_button '更新する'

        expect(page).to have_content 'タスクが更新されました！'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'this is a task2'
        expect(page).to have_content '高'
        expect(page).to have_content '完了'
        expect(page).to have_content Date.current.strftime('%Y/%m/%d')
      end
    end
  end

  describe 'ordering' do
    before do
      create(:task, { user_id: user.id, created_at: 2.days.ago })
      create(:task2, { user_id: user.id, created_at: 1.day.ago })
      create(:task3, { user_id: user.id })
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
        expect(page).to have_content('▲')
        expect(page.all('.task-priority').map(&:text)).to eq %w[低 中 高]
        click_on '優先度'
        expect(page).to have_content('▼')
        expect(page.all('.task-priority').map(&:text)).to eq %w[高 中 低]
      end

      it 'tasks ordered by status' do
        subject
        click_on '状態'
        expect(page).to have_content('▲')
        expect(page.all('.task-status').map(&:text)).to eq %w[待機中 実施中 完了]
        click_on '状態'
        expect(page).to have_content('▼')
        expect(page.all('.task-status').map(&:text)).to eq %w[完了 実施中 待機中]
      end

      it 'tasks ordered by due' do
        subject
        click_on '期限'
        expect(page).to have_content('▲')
        expect(page.all('.task-due').map(&:text)).to eq %W[2020/12/31\ 00:00 2021/01/01\ 00:00 2021/01/02\ 00:00]
        click_on '期限'
        expect(page).to have_content('▼')
        expect(page.all('.task-due').map(&:text)).to eq %W[2021/01/02\ 00:00 2021/01/01\ 00:00 2020/12/31\ 00:00]
      end
    end
  end

  describe 'search' do
    before do
      create(:task, { user_id: user.id, created_at: 2.days.ago })
      create(:task2, { user_id: user.id, created_at: 1.day.ago })
      create(:task3, { user_id: user.id })
    end

    context 'visit tasks_path' do
      subject { visit tasks_path }

      it 'tasks searched by name `task2`' do
        subject
        fill_in 'search_by_name', with: 'task2'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content '2021/01/02'
      end

      it 'tasks searched by priority `低`' do
        subject
        select '低', from: 'search_by_priority'
        click_on '検索'
        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'
        expect(page).to have_no_content 'task2'
        expect(page).to have_no_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content '2021/01/02'
      end

      it 'tasks searched by status `完了`' do
        subject
        select '完了', from: 'search_by_status'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_no_content 'task2'
        expect(page).to have_no_content '2021/01/01'
        expect(page).to have_content 'task3'
        expect(page).to have_content '高'
        expect(page).to have_content '完了'
        expect(page).to have_content '2021/01/02'
      end

      it 'tasks searched by name `task`, priority `中`, and status `実施中`' do
        subject
        fill_in 'search_by_name', with: 'task'
        select '中', from: 'search_by_priority'
        select '実施中', from: 'search_by_status'
        click_on '検索'
        expect(page).to have_no_content 'task1'
        expect(page).to have_no_content '2020/12/31'
        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
        expect(page).to have_no_content 'task3'
        expect(page).to have_no_content '2021/01/02'
      end
    end
  end
end
