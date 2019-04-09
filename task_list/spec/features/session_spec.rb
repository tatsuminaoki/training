require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  feature 'ログイン' do
    background do
      user = create(:user)
      login(user)
      @task = create(:task, user_id: user.id)
    end

    scenario 'ログインするとフラッシュメッセージが表示される' do
      expect(page).to have_content 'ログインしました'
    end

    scenario 'ログアウト出来る' do
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました'
    end
  end

  feature 'ログインのバリデーション' do
    background do
      @user_login = create(:user)
      visit new_session_path
    end

    scenario 'emailが空のときにバリデーションエラーメッセージが出ること' do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: @user_login.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end

    scenario 'passwordが空のときにバリデーションエラーメッセージが出ること' do
      fill_in 'メールアドレス', with: @user_login.email
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end
  end

  feature '画面遷移' do
    scenario 'メンテナンス中に正しくメンテナンス画面に遷移すること' do
      visit new_session_path
      expect(page).to have_content 'ログイン'
      maintenance = create(:maintenance, is_maintenance: 1)
      visit new_session_path
      expect(page).to have_content 'メンテナンス中'
    end
  end
end
