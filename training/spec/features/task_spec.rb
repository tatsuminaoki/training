require 'rails_helper'

RSpec.describe 'Task', type: :feature do
  let(:task) { FactoryBot.create(:task) }

  describe 'ユーザーがタスク一覧にアクセスする' do
    before do
      visit tasks_path
    end

    context 'タスクの作成をクリックしたとき' do
      it 'タスク作成ページに遷移する' do
        click_on 'タスクの作成'
        expect(current_path).to eq new_task_path
      end
    end

    context 'タスク名をクリックしたとき' do
      it 'タスク詳細ページに遷移する' do
        save_and_open_page
        click_on task.name
        expect(current_path).to eq task_path
      end
    end
  end

  describe 'ユーザーがタスク作成ページにアクセスする' do
    context 'タスク情報を入力して作成する' do
      it 'タスク一覧に対象のタスクが表示される' do
      end

      it '作成しました　とメッセージが表示される' do
      end
    end
  end

  describe 'ユーザーがタスク編集ページにアクセスする' do
    context 'タスク情報を入力して更新する' do
      it '詳細ページに遷移する' do
      end

      it '更新しました　とメッセージが表示される' do
      end
    end

    context 'タスクの削除ボタンをクリックしたとき' do
      it '確認メッセージが表示される' do
      end

      context 'OKした場合' do
        it 'タスク一覧ページに遷移する' do
        end

        it '削除しました　とメッセージが表示される' do
        end
      end
    end
  end
end
