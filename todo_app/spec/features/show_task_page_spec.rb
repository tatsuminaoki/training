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
end



