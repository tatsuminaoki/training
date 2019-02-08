require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA') }
  let!(:user_b) { create(:user, name: 'ユーザーB', email: 'b@a.a') }
  let!(:user_c) { create(:user, name: 'ユーザーC', email: 'c@a.a') }

  describe 'ユーザー一覧表示機能' do
    context 'ユーザー一覧画面へ遷移した時' do
      background do
        login
        visit admin_users_path
      end

      scenario '作成したユーザーが表示される' do
        expect(page).to have_content 'ユーザーA'
        expect(page).to have_content 'ユーザーB'
        expect(page).to have_content 'ユーザーC'
      end
    end
  end
end
