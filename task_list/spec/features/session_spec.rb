require 'rails_helper'

RSpec.feature 'Sessions', type: :feature do
  feature 'ログイン' do
    before do
      user = create(:user, id: 1)
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    scenario 'ログインするとフラッシュメッセージが表示される' do
      expect(page).to have_content 'ログインしました'
    end

    scenario 'ログアウト出来る' do
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました'
    end
  end

  before do
    @user = create(:user, id: 2)
    visit new_session_path
  end

  feature 'ログインのバリデーション' do
    scenario 'emailが空のときにバリデーションエラーメッセージが出ること' do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: @user.password
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end

    scenario 'passwordが空のときにバリデーションエラーメッセージが出ること' do
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end
  end
end