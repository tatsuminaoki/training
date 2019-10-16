# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:user) { create(:user) }
  before do
    visit '/ja/login'
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end
  scenario 'user visit tasks index/root' do
    visit '/ja/tasks'
    expect(page).to have_text('タスク一覧')
    visit '/'
    expect(page).to have_text('タスク一覧')
  end

  scenario 'user create new task' do
    visit '/'
    expect(page).to have_button('タスク追加')
    click_button 'タスク追加'
    expect(page).to have_text('タスク追加')
    expect(page).to have_button('追加')
    fill_in 'task[title]', with: 'タスク1'
    fill_in 'task[body]', with: 'タスク1の詳細です。'

    click_button '追加'
    expect(page).to have_text('タスク1')
    expect(page).to have_text('タスク1の詳細です。')
  end

  describe 'task show, editing and destroying' do
    let!(:original_task) { create(:task, user: user, title: '古い', body: '古い説明') }
    scenario 'show existing task' do
      visit '/'
      expect(page).to have_text('古い')
      within "\#task-#{original_task.id}" do
        click_button '詳細'
      end
      expect(page).to have_text('古い')
      expect(page).to have_text('古い説明')
      expect(page).to have_button('←タスク一覧へ')
      expect(page).to have_button('編集')
      expect(page).to have_button('削除')
    end

    scenario 'user edit existing task' do
      visit '/'
      expect(page).to have_text('古い')
      within "\#task-#{original_task.id}" do
        click_button '編集'
      end
      expect(page).to have_text('古い')
      fill_in 'task[title]', with: '新しい'
      fill_in 'task[body]', with: '新しい説明'
      click_button '更新'
      expect(page).to have_text('新しい')
      expect(page).to have_text('新しい説明')
    end

    scenario 'user destroy existing task' do
      visit '/'
      expect(page).to have_text('古い')
      within "\#task-#{original_task.id}" do
        click_button '削除'
      end
      expect(page).to_not have_text('古い')
      expect(page).to_not have_text('古い説明')
    end
  end

  scenario 'tasks is ordered by created_at with descending order' do
    expected_order = %w[task3 task2 task1]
    visit '/ja/tasks'
    click_button 'タスク追加'
    fill_in 'task[title]', with: 'task1'
    click_button '追加'
    expect(page).to have_text('タスクが保存されました。')
    expect(page).to have_button('タスク追加')
    click_button 'タスク追加'
    fill_in 'task[title]', with: 'task2'
    click_button '追加'
    expect(page).to have_text('タスクが保存されました。')
    expect(page).to have_button('タスク追加')
    click_button 'タスク追加'
    fill_in 'task[title]', with: 'task3'
    click_button '追加'
    expect(page.all('.task-name').map(&:text)).to eq expected_order
  end

  scenario 'task with empty title should not be saved' do
    visit '/ja/tasks'
    click_button 'タスク追加'
    click_button '追加'
    expect(page).to have_text('Titleを入力してください')
  end

  describe 'task sorting' do
    before do
      create(:task, user: user, title: 'task1', task_limit: '2020-01-01 01:01:01')
      create(:task, user: user, title: 'task2', task_limit: '2020-02-02 02:02:02')
      create(:task, user: user, title: 'task3', task_limit: '2020-03-03 03:03:03')
    end
    scenario 'task can be order by task_limit' do
      visit '/ja/tasks'
      expect(page.all('.task-limit').map(&:text)).to eq ['2020/03/03 03:03', '2020/02/02 02:02', '2020/01/01 01:01']
      click_link('終了期限')
      sleep 0.5
      expect(page.all('.task-limit').map(&:text)).to eq ['2020/03/03 03:03', '2020/02/02 02:02', '2020/01/01 01:01'].reverse
      click_link('終了期限')
      sleep 0.5
      expect(page.all('.task-limit').map(&:text)).to eq ['2020/03/03 03:03', '2020/02/02 02:02', '2020/01/01 01:01']
    end
  end

  describe 'task searching' do
    before do
      create(:task, user: user, title: 'task1', aasm_state: 'not_yet')
      create(:task, user: user, title: '2nd t(ask)', aasm_state: 'on_going')
      create(:task, user: user, title: 'no. 3rd', aasm_state: 'done')
    end
    scenario 'search with title and aasm_state' do
      visit '/ja/tasks'
      expect(page.all('.task-name').map(&:text)).to eq ['no. 3rd', '2nd t(ask)', 'task1']
      fill_in 'q[title_cont]', with: '2nd'
      click_button('検索')
      expect(page.all('.task-name').map(&:text)).to eq ['2nd t(ask)']
      fill_in 'q[title_cont]', with: 'ask'
      click_button('検索')
      expect(page.all('.task-name').map(&:text)).to eq ['2nd t(ask)', 'task1']
      fill_in 'q[title_cont]', with: ''
      select '完了', from: 'q[aasm_state_eq]'
      click_button('検索')
      expect(page.all('.task-name').map(&:text)).to eq ['no. 3rd']
      fill_in 'q[title_cont]', with: '4th'
      select '', from: 'q[aasm_state_eq]'
      click_button('検索')
      expect(page).to have_text('タスクはありません。')
    end
  end
end
