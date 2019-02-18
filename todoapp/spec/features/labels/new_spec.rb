require 'rails_helper'

feature 'ラベル管理機能', type: :feature do
  let!(:user_a) { create(:user) }

  describe '新規作成機能' do
    background do
      login
      visit new_label_path

      # ユーザーのフォーム入力
      fill_in :label_name, with: 'らべるだよ'

      # フォームの内容をチェック
      expect(page).to have_field :label_name, with: 'らべるだよ'

      # 作成
      click_button '登録する'
    end

    context '新規作成画面で正しい情報を入力した時' do
      scenario '登録後の画面で内容が正常に表示される' do
        expect(page).to have_content 'らべるだよ'
      end
    end
  end
end
