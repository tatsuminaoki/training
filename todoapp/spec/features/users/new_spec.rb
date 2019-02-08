require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA') }

  describe '新規作成機能' do
    background do
      login
      visit new_admin_user_path

      # ユーザーのフォーム入力
      fill_in :user_name, with: 'なまえだよ'
      fill_in :user_email, with: 'aaa@a.a'
      fill_in :user_password, with: 'ぱすわーど'

      # フォームの内容をチェック
      expect(page).to have_field :user_name, with: 'なまえだよ'
      expect(page).to have_field :user_email, with: 'aaa@a.a'
      expect(page).to have_field :user_password, with: 'ぱすわーど'

      # 作成
      click_button '登録する'
    end

    context '新規作成画面で正しい情報を入力した時' do
      scenario '登録後の画面で内容が正常に表示される' do
        expect(page).to have_content 'なまえだよ'
        expect(page).to have_content 'aaa@a.a'
        expect(page).to have_no_content 'ぱすわーど'
      end
    end
  end
end
