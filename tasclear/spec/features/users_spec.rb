# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'ログインをしない' do
    scenario 'ログインせずにトップページにアクセスするとログインページに遷移する' do
      visit root_path
      expect(page).to have_current_path '/sessions/new'
    end

    scenario 'メールアドレスを間違えるとログインに失敗する' do
      create(:user, id: 1)
      visit root_path
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end

    scenario 'パスワードを間違えるとログインに失敗する' do
      create(:user, id: 1)
      visit root_path
      fill_in 'メールアドレス', with: 'raku@example.com'
      fill_in 'パスワード', with: 'hogehoge'
      click_button 'ログイン'
      expect(page).to have_content 'ログインに失敗しました'
    end
  end

  context 'ログインをする' do
    before do
      user = create(:user, id: 1)
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    scenario 'ログインするとフラッシュメッセージが表示されトップページに遷移する' do
      expect(page).to have_current_path '/'
      expect(page).to have_content 'ログインしました'
    end

    scenario 'ログアウト出来る' do
      click_link 'ログアウト'
      expect(page).to have_content 'ログアウトしました'
    end
  end

  scenario '新規登録出来る' do
    expect do
      visit root_path
      click_link '新規登録'
      fill_in '名前', with: 'ほげほげ'
      fill_in 'メールアドレス', with: 'hogehoge@example.com'
      fill_in 'パスワード', with: 'hogehoge'
      click_button '登録する'
      expect(page).to have_content '登録完了しました'
    end.to change { User.count }.by(1)
  end
end
