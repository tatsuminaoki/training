# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'アカウント', with: 'tadashi.toyokura'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  feature 'detail' do
    before do
      create(:task, name: "#{user.name}-task", user: user)
    end

    scenario 'user detail page with own tasks.' do
      visit admin_user_path(user)

      expect(page).to have_text("#{user.name}-task")
    end
  end

  feature 'creation' do
    scenario 'user can create a new user' do
      visit admin_users_path
      click_link '登録'
      fill_in 'アカウント', with: 'new_account'
      fill_in 'パスワード', with: 'password'
      click_button '送信'

      expect(page).to have_text('ユーザを作成しました')
    end
  end

  feature 'modification' do
    scenario 'user can edit a user' do
      visit edit_admin_user_path(user)

      fill_in 'アカウント', with: 'renamed_account'
      fill_in 'パスワード', with: 'pass'
      click_button '送信'

      expect(page).to have_text('ユーザ情報を更新')
    end
  end

  feature 'link to management pages' do
    scenario 'user can visit user management pages' do
      click_link '管理画面'
      expect(page).to have_content('管理機能を実行しています')
    end
  end

  feature 'listing' do
    before do
      4.times do |index|
        create(:user, name: 'user-on-list', account: "account#{index}")
      end

      visit admin_users_path
    end

    scenario 'two user listed on first page' do
      assert_text('user-on-list', count: 1)
    end

    scenario 'two user listed on middle page' do
      click_link '次'
      assert_text('user-on-list', count: 2)
    end

    scenario 'one user listed on last page' do
      click_link '最後'
      assert_text('user-on-list', count: 1)
    end
  end
end
