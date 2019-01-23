require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA') }
  let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', user: user_a) }

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context '一覧表示画面へ遷移した時' do
      before do
        visit tasks_path
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '詳細表示機能' do
    context '詳細表示画面へ遷移した時' do
      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    before do
      visit new_task_path

      # タスクのフォーム入力
      fill_in :task_title, with: 'たすくだよ'
      fill_in :task_description, with: 'たすくのせつめいだよ'
      fill_in :task_end_at, with: '002010-01-01' # NOTE: 年は6桁にしないと日付が入力できなかった

      # フォームの内容をチェック
      expect(page).to have_field :task_title, with: 'たすくだよ'
      expect(page).to have_field :task_description, with: 'たすくのせつめいだよ'
      expect(page).to have_field :task_end_at, with: '2010-01-01'

      # 作成
      click_button 'Create Task'
    end

    context '規作成画面で正しい情報を入力した時' do
      example '登録後の画面で内容が正常に表示される' do
        expect(page).to have_content 'たすくだよ'
        expect(page).to have_content 'たすくのせつめいだよ'
        expect(page).to have_content '2010年01月01日'
      end
    end
  end
end
