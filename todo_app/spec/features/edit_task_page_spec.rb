# frozen_string_literal: true

require 'rails_helper'

describe 'タスク編集画面', type: :feature do
  let(:task) do
    create(:task,
           title: 'before task title',
           description: 'before task description',
           deadline: Time.new(2017, 1, 1, 1, 1, 1).getlocal,
           status: 'not_start',
           priority: 'low')
  end

  before do
    login
    visit edit_task_path(task)
  end

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        logout
        visit edit_task_path(task)
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'タスク編集画面が表示されること' do
        expect(page).to have_css('#edit_task')
      end
    end
  end

  describe '登録されているタスク情報を表示する' do
    it 'タスク名が表示されていること' do
      expect(page.find('#task_title').value).to eq task.title
    end

    it '説明が表示されていること' do
      expect(page.find('#task_description').value).to eq task.description
    end

    it '期日が表示されていること' do
      expect(page.find('#task_deadline_1i').value).to eq task.deadline.strftime('%Y')
      expect(page.find('#task_deadline_2i').value).to eq task.deadline.strftime('%-m')
      expect(page.find('#task_deadline_3i').value).to eq task.deadline.strftime('%-d')
      expect(page.find('#task_deadline_4i').value).to eq task.deadline.strftime('%H')
      expect(page.find('#task_deadline_5i').value).to eq task.deadline.strftime('%M')
    end

    it 'ステータスが表示されていること' do
      expect(page.find('#task_status').value).to eq task.status
    end

    it '優先度が表示されていること' do
      expect(page.find('#task_priority').value).to eq task.priority
    end
  end

  describe 'タスクを更新する' do
    context '正常に更新できる場合' do
      it '値を変更して更新できること' do
        within('.edit_task') do
          fill_in I18n.t('page.task.labels.title'), with: 'after task title'
          fill_in I18n.t('page.task.labels.description'), with: 'after task title description'
          fill_in_datetime_select(
              Time.new(2018, 2, 3, 4, 5, 6).getlocal,
              'task_deadline')
          select '進行中', from: 'task_status'
          select '高い', from: 'task_priority'
        end
        click_on I18n.t('helpers.submit.update')

        expect(page).to have_css('#todo_app_task_list')
        expect(page).to have_content I18n.t('success.update', it: Task.model_name.human)
      end

      context '更新に失敗する場合' do
        context 'タスク名が空の場合' do
          it 'エラーメッセージが表示されること' do
            within('.edit_task') do
              fill_in I18n.t('page.task.labels.title'), with: ''
              fill_in I18n.t('page.task.labels.description'), with: 'after task title description'
              fill_in_datetime_select(
                  Time.new(2018, 2, 3, 4, 5, 6).getlocal,
                  'task_deadline')
              select '進行中', from: 'task_status'
              select '高い', from: 'task_priority'
            end
            click_on I18n.t('helpers.submit.update')

            expect(page).to have_css('#edit_task')
            expect(page).to have_content('Titleを入力してください')
          end
        end
      end

      context '編集をやめたい場合' do
        it 'キャンセルボタンクリックで一覧画面に戻れること' do
          click_on I18n.t('helpers.submit.cancel')
          expect(page).to have_css('#todo_app_task_list')
        end
      end
    end
  end
end
