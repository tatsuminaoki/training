require 'spec_helper'
require 'rails_helper'

describe 'タスク詳細画面', type: :feature do
  before do
    task = create(:task, title: 'Rspec test 1' )
    visit task_path(task)
  end

  describe 'アクセス' do
    it '画面が表示されていること' do
      expect(page).to have_css('#show_task')
    end
  end

  describe 'タスクの登録内容の表示確認' do
    it 'タスク名が表示されていること' do
      tr = find(:css, 'table tbody').all('tr')[0]
      expect(tr).to have_content(I18n.t('page.task.label.title'))
      expect(tr).to have_content('Rspec test 1')
    end

    it '内容が表示されていること' do
      tr = find(:css, 'table tbody').all('tr')[1]
      expect(tr).to have_content(I18n.t('page.task.label.description'))
      expect(tr).to have_content('This is a sample description')
    end

    it '期日が表示されていること' do
      tr = find(:css, 'table tbody').all('tr')[2]
      expect(tr).to have_content(I18n.t('page.task.label.deadline'))
      expect(tr).to have_content('2018-03-01')
    end

    it 'ステータスが表示されていること' do
      tr = find(:css, 'table tbody').all('tr')[3]
      expect(tr).to have_content(I18n.t('page.task.label.status'))
      expect(tr).to have_content(Task.human_attribute_name('status.progress'))
    end

    it '優先度が表示されていること' do
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(I18n.t('page.task.label.priority'))
      expect(tr).to have_content(Task.human_attribute_name('priority.high'))
    end
  end

  describe '一覧画面への遷移', type: :feature do

    it '戻るボタンが表示されていること' do
      expect(find_link(I18n.t('helpers.submit.back')).visible?).to be_truthy
    end

    it '戻るボタンクリックで一覧画面に遷移すること' do
      click_on (I18n.t('helpers.submit.back'))
      expect(page).to have_css('#todo_app_task_list')
    end

  end

  describe 'ステータスの登録値のパターンテスト', type: :feature do

    it '未着手と表示されること' do
      show_task 'not_start'
      tr = find(:css, 'table tbody').all('tr')[3]
      expect(tr).to have_content(Task.human_attribute_name('status.not_start'))
    end

    it '進行中と表示されること' do
      show_task 'progress'
      tr = find(:css, 'table tbody').all('tr')[3]
      expect(tr).to have_content(Task.human_attribute_name('status.progress'))
    end

    it '完了と表示されること' do
      show_task 'done'
      tr = find(:css, 'table tbody').all('tr')[3]
      expect(tr).to have_content(Task.human_attribute_name('status.done'))
    end

    def show_task(status_type)
      @task = create(:task, title: 'Rspec test 1', status: status_type )
      visit task_path(@task)
    end
  end

  describe '優先度の登録値のパターンテスト', type: :feature do

    it '低いと表示されること' do
      show_task 'low'
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(Task.human_attribute_name('priority.low'))
    end

    it '通常と表示されること' do
      show_task 'normal'
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(Task.human_attribute_name('priority.normal'))
    end

    it '高いと表示されること' do
      show_task 'high'
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(Task.human_attribute_name('priority.high'))
    end

    it '急いでと表示されること' do
      show_task 'quickly'
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(Task.human_attribute_name('priority.quickly'))
    end

    it '今すぐと表示されること' do
      show_task 'right_now'
      tr = find(:css, 'table tbody').all('tr')[4]
      expect(tr).to have_content(Task.human_attribute_name('priority.right_now'))
    end

    def show_task(priority_type)
      @task = create(:task, title: 'Rspec test 1', priority: priority_type )
      visit task_path(@task)
    end
  end
end



