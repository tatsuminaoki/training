# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  let!(:user) { create(:user, account: 'tadashi.toyokura', password: 'password', role: 'admin') }

  before do
    visit login_path
    fill_in 'アカウント', with: 'tadashi.toyokura'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  feature 'role is user' do
    before do
      user.update(role: 'user')
      visit root_path
    end

    scenario 'normal user can not access management pages.' do
      expect(page).to_not have_text('管理画面')
      visit admin_users_path
      expect(page).to have_current_path(root_path)
      visit new_admin_user_path
      expect(page).to have_current_path(root_path)
      visit edit_admin_user_path(user)
      expect(page).to have_current_path(root_path)
    end
  end

  feature 'delete' do
    let(:normal_user) { create(:user, account: 'normal-account') }

    scenario 'admin can delete a user' do
      visit admin_user_path(normal_user)
      click_link '削除'
      expect(page).to have_text('ユーザを削除しました')
    end

    scenario 'admin can not delete a last admin user' do
      visit admin_user_path(user)
      click_link '削除'
      expect(page).to have_text('これ以上管理ユーザを削除することができません')
    end
  end

  feature 'detail' do
    before do
      create(:task, name: "#{user.name}-task", user: user)
      visit admin_user_path(user)
    end

    scenario 'tasks in user detail page' do
      expect(page).to have_text("#{user.name}-task")
    end

    scenario 'can find user details in the detail page.' do
      expect(page).to have_text(user.name)
      expect(page).to have_text(user.account)
    end
  end

  feature 'creation' do
    before do
      visit admin_users_path
      click_link '登録'
    end

    scenario 'admin can create a user' do
      fill_in 'アカウント', with: 'new_account'
      fill_in 'パスワード', with: 'password'
      click_button '送信'
      expect(page).to have_text('ユーザを作成しました')
    end

    scenario 'admin can create an admin user' do
      fill_in 'アカウント', with: 'new_account'
      fill_in 'パスワード', with: 'password'
      select '管理', from: 'user_role'
      click_button '送信'
      expect(page).to have_text('ユーザを作成しました')
    end

    scenario 'user can not create a new user with empty account' do
      fill_in 'ユーザ名（表示用）', with: 'name'
      fill_in 'パスワード', with: 'password'
      click_button '送信'

      expect(page).to have_text('アカウントを入力してください')
    end

    scenario 'user can not create a new user with invalid account (length lt 4)' do
      fill_in 'ユーザ名（表示用）', with: 'name'
      fill_in 'アカウント', with: 'a' * 3
      fill_in 'パスワード', with: 'password'
      click_button '送信'

      expect(page).to have_text('アカウントは4文字以上で入力してください')
    end

    scenario 'user can not create a new user with empty password' do
      fill_in 'アカウント', with: 'account'
      fill_in 'パスワード', with: ''
      click_button '送信'

      expect(page).to have_text('パスワードを入力してください')
    end

    scenario 'user can not create a new user with invalid password (length lt 4)' do
      fill_in 'アカウント', with: 'account'
      fill_in 'パスワード', with: 'ppp'
      click_button '送信'

      expect(page).to have_text('パスワードは4文字以上で入力してください')
    end
  end

  feature 'modification' do
    before do
      visit edit_admin_user_path(user)
    end

    scenario 'admin can edit a user' do
      fill_in 'アカウント', with: 'renamed_account'
      fill_in 'パスワード', with: 'pass'
      click_button '送信'
      expect(page).to have_text('ユーザ情報を更新しました')
    end

    scenario 'admin can change a user to an admin user' do
      select '管理', from: 'user_role'
      click_button '送信'
      expect(page).to have_text('ユーザ情報を更新しました')
    end

    scenario 'user can modify a user with empty password' do
      fill_in 'パスワード', with: ''
      click_button '送信'

      expect(page).to have_text('ユーザ情報を更新しました')
      expect(page).to have_text('tadashi.toyokura')
    end

    scenario 'user can not modify a user with empty account' do
      fill_in 'アカウント', with: ''
      click_button '送信'

      expect(page).to have_text('アカウントを入力してください')
    end

    scenario 'user can not modify a user with invalid account (length lt 4)' do
      fill_in 'アカウント', with: 'aaa'
      click_button '送信'

      expect(page).to have_text('アカウントは4文字以上で入力してください')
    end

    scenario 'user can not modify a user with invalid password (length lt 4)' do
      fill_in 'パスワード', with: 'ppp'
      click_button '送信'

      expect(page).to have_text('パスワードは4文字以上で入力してください')
    end
  end

  feature 'link to management pages' do
    scenario 'admin can visit user management pages' do
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
