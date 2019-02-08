require 'rails_helper'

feature 'タスク管理機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA') }

  describe '新規作成機能' do
    background do
      login
      visit new_task_path

      # タスクのフォーム入力
      fill_in :task_title, with: 'たすくだよ'
      fill_in :task_description, with: 'たすくのせつめいだよ'
      fill_in :task_end_at, with: '2100-01-01'

      # フォームの内容をチェック
      expect(page).to have_field :task_title, with: 'たすくだよ'
      expect(page).to have_field :task_description, with: 'たすくのせつめいだよ'
      expect(page).to have_field :task_end_at, with: '2100-01-01'

      # 作成
      click_button '登録する'
    end

    context '規作成画面で正しい情報を入力した時' do
      scenario '登録後の画面で内容が正常に表示される' do
        expect(page).to have_content 'たすくだよ'
        expect(page).to have_content 'たすくのせつめいだよ'
        expect(page).to have_content '2100/01/01 00:00:00'
      end
    end
  end
end
