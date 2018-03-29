# frozen_string_literal: true

require 'rails_helper'

describe 'タスク登録画面', type: :feature do
  before do
    login
    visit new_task_path
  end

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        logout
        visit new_task_path
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'タスク登録画面が表示されること' do
        expect(page).to have_css('#add_task')
      end
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

  describe 'ラベルの登録処理' do
    let(:label_area) { '#task_label_list' }

    before do
      within('#new_task') do
        fill_in I18n.t('page.task.labels.title'), with: 'Label test'
      end
      add_label(label_area, labels)
      click_on I18n.t('helpers.submit.create')
    end

    context 'POSTで受け渡したリストの登録検証' do
      let(:labels) { ['Label1', 'ラベル2', 'ラベル らべる3'] }

      it 'タスクに紐づいて保存できていること' do
        task = Task.find_by(title: 'Label test')
        expect(task.label_list).to match_array labels
      end
    end

    context 'ラベルのバリデーション' do
      let(:labels) { %w[Label1 Label2 Label3 Label4 Label5 Label6] }

      it 'ラベルは5つ以上入力できないこと' do
        task = Task.find_by(title: 'Label test')
        expect(task.label_list).to contain_exactly(*labels.first(5))
      end
    end
  end
end
