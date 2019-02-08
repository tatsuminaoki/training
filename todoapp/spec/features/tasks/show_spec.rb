require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let!(:task_a) { create(:task, :first_task, user: user_a) }

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    scenario { expect(page).to have_content '最初のタスク' }
  end

  describe '詳細表示機能' do
    context '詳細表示画面へ遷移した時' do
      background do
        login
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end
end
