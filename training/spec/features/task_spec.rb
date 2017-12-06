require 'rails_helper'

RSpec.describe 'Task', type: :feature do
  let!(:task) { FactoryBot.create(:task) }

  describe 'ユーザーがタスク一覧にアクセスする' do
    before do
      visit tasks_path
    end

    it '登録されたタスクが表示される' do
      expect(page).to have_content task.name
      expect(page).to have_content task.description
    end

    context 'タスクの作成をクリックしたとき' do
      it 'タスク作成ページに遷移する' do
        click_on 'タスクの作成'
        expect(current_path).to eq new_task_path
      end
    end

    context 'タスク名をクリックしたとき' do
      it 'タスク詳細ページに遷移する' do
        click_on task.name
        expect(current_path).to eq task_path(task.id)
      end
    end
  end

  describe 'ユーザーがタスク作成ページにアクセスする' do
    context 'タスク情報を入力して作成する' do
      before do
        visit new_task_path
        fill_in 'Name', with: 'hoge'
        fill_in 'Description', with: 'fuga'
        click_on '作成'
      end

      it 'タスク詳細ページに遷移する' do
        expect(current_path).to eq task_path(Task.last.id)
        expect(page).to have_content Task.last.name
        expect(page).to have_content Task.last.description
      end

      it '作成しました　とメッセージが表示される' do
        expect(page).to have_content '作成しました'
      end
    end
  end

  describe 'ユーザーがタスク編集ページにアクセスする' do
    before do
      visit edit_task_path(task.id)
    end

    context 'タスク情報を入力して更新する' do
      let(:update_name) { 'abcde' }
      before do
        fill_in 'Name', with: update_name
        click_on '更新'
      end

      it '詳細ページに遷移する' do
        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content update_name
      end

      it '更新しました　とメッセージが表示される' do
        expect(page).to have_content '更新しました'
      end
    end
  end

  describe 'ユーザーがタスク詳細ページにアクセスする' do
    before do
      visit task_path(task.id)
    end

    context '一覧ボタンをクリックしたとき' do
      before { click_on '一覧' }

      it '一覧ページに遷移する' do
        expect(current_path).to eq tasks_path
      end
    end

    context '編集ボタンをクリックしたとき' do
      before { click_on '編集' }

      it '編集ページに遷移する' do
        expect(current_path).to eq edit_task_path(task.id)
      end
    end

    context '削除ボタンをクリックしたとき' do
      before { click_on '削除' }

      it '一覧ページに遷移する' do
        expect(current_path).to eq tasks_path
      end
      it '削除しました　とメッセージが表示される' do
        expect(page).to have_content '削除しました'
      end
    end
  end
end
