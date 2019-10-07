require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
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
    let!(:original_task) { Task.create(title: '古い', body: '古い説明') }
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
    expected_order = ['task3', 'task2', 'task1']
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
end
