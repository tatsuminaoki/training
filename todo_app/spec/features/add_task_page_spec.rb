require 'rails_helper'
require 'features/test_helpers'

RSpec.configure do |config|
  config.include TestHelpers
end

describe 'タスク登録画面' , type: :feature do
  before do
    visit new_task_path
  end

  describe 'アクセス' do
    it '画面が表示されていること' do
      expect(page).to have_css('#add_task')
    end
  end

  describe 'タスクを登録する' do
    context '正常に登録できる場合' do
      it 'タスクが登録できること' do
        within('#new_task') do
          fill_in I18n.t('page.task.labels.title'), with: 'Test task'
          fill_in I18n.t('page.task.labels.description'), with: 'This is test description'
          fill_in_datetime_select(
              DateTime.strptime('2017/01/01 01:01:01', '%Y/%m/%d %H:%M:%S'),
              'task_deadline')
          select '進行中', from: 'task_status'
          select '高い', from: 'task_priority'
        end
        click_on I18n.t('helpers.submit.create')

        expect(page).to have_css('#todo_app_task_list')
        expect(page).to have_content I18n.t('success.create', it: Task.model_name.human)
      end
    end

    context '登録に失敗する場合' do
      context 'タスク名が空の場合' do
        it 'エラーメッセージが表示されること' do
          within('#new_task') do
            fill_in I18n.t('page.task.labels.title'), with: ''
            fill_in I18n.t('page.task.labels.description'), with: 'This is test description'
            fill_in_datetime_select(
                DateTime.strptime('2017/01/01 01:01:01', '%Y/%m/%d %H:%M:%S'),
                'task_deadline')
            select '進行中', from: 'task_status'
            select '高い', from: 'task_priority'
          end
          click_on I18n.t('helpers.submit.create')

          expect(page).to have_css('#add_task')
          expect(page).to have_content('Titleを入力してください')
        end
      end
    end

    context '登録をやめたい場合' do
      it 'キャンセルボタンクリックで一覧画面に戻れること' do
        click_on I18n.t('helpers.submit.cancel')
        expect(page).to have_css('#todo_app_task_list')
      end
    end
  end
end
