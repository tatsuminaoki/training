require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA') }

  describe '詳細表示機能' do
    context '詳細表示画面へ遷移した時' do
      background do
        login
        visit admin_user_path(user_a)
      end

      scenario 'ユーザーの情報が表示されている' do
        expect(page).to have_content 'ユーザーA'
      end
    end
  end
end
