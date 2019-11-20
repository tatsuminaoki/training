# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'GET #new' do
    before do
      visit new_user_path
    end

    context 'when you correctly fill out the form' do
      it 'enables you to successfully create a new user' do
        fill_in 'user_name', with: 'user1'
        fill_in 'user_login_id', with: 'id1'
        fill_in 'user_password', with: 'password1'
        fill_in 'user_password_confirmation', with: 'password1'
        click_button '登録する'

        expect(page).to have_content 'ユーザーが追加されました！'
        expect(page).to have_content 'ログインIDとパスワードを入力してください'

        # You will log in to verify that you have successfully create the user.
        fill_in 'session_login_id', with: 'id1'
        fill_in 'session_password', with: 'password1'
        click_button 'ログイン'

        expect(page).to have_content 'ログアウト'
      end
    end
  end
end
