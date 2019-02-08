require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let!(:task_a) { create(:task, :first_task, user: user_a) }

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    scenario { expect(page).to have_content '最初のタスク' }
  end

  shared_examples_for 'ログイン画面が表示される' do
    scenario { expect(page).to have_content 'ログイン' }
  end

  describe 'ログイン機能' do
    context 'ログインしいる時' do
      background do
        login
        visit tasks_path
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ログインしてない時' do
      background do
        visit tasks_path
      end

      it_behaves_like 'ログイン画面が表示される'
    end

    context 'ログアウトした時' do
      background do
        login
        visit tasks_path
        logout
      end

      it_behaves_like 'ログイン画面が表示される'
    end
  end
end
