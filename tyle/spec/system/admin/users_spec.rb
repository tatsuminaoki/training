# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:user) }
  let!(:user2) { create(:user2) }

  before do
    create(:task, user_id: user.id)
    create(:task2, user_id: user.id)

    # login
    visit login_path
    fill_in 'session_login_id', with: user.login_id
    fill_in 'session_password', with: 'password1'
    click_on 'ログイン'
    sleep 1
  end

  describe 'view' do
    context 'visit admin_users_path' do
      subject { visit admin_users_path }

      it 'lists the appropriate users' do
        subject
        expect(page).to have_content 'user1'
        expect(page).to have_content 'id1'
        expect(page).to have_content '管理者'
        expect(page).to have_content '2'
        expect(page).to have_content 'user2'
        expect(page).to have_content 'id2'
        expect(page).to have_content '0'
      end
    end

    context 'visit new_admin_user_path' do
      subject { visit new_admin_user_path }

      it 'enables you to create a new user' do
        subject
        fill_in 'user_name', with: 'user3'
        fill_in 'user_login_id', with: 'id3'
        fill_in 'user_password', with: 'password3'
        fill_in 'user_password_confirmation', with: 'password3'
        select '一般', from: 'user_role'
        click_button '登録する'

        expect(page).to have_content 'ユーザーが追加されました！'
        expect(page).to have_content 'user3'
        expect(page).to have_content 'id3'
        expect(page).to have_content '0'
      end
    end

    context 'visit admin_user_path(user)' do
      subject { visit admin_user_path(user) }

      it 'shows the appropriate user and its tasks' do
        subject
        expect(page).to have_content 'user1'
        expect(page).to have_content 'id1'
        expect(page).to have_content '管理者'
        expect(page).to have_content '2'

        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
      end

      it 'enables you to delete the user with the delete button' do
        subject
        expect(page).to have_content 'user1'
        expect(page).to have_content 'id1'
        expect(page).to have_content '管理者'
        expect(page).to have_content '2'

        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'

        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'user1'
        expect(page).to have_content 'id1'
        expect(page).to have_content '管理者'
        expect(page).to have_content '2'

        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
      end
    end

    context 'visit admin_user_path(user2)' do
      subject { visit admin_user_path(user2) }

      it 'enables you to delete the user with the delete button' do
        subject
        expect(page).to have_content 'user2'
        expect(page).to have_content 'id2'
        expect(page).to have_content '0'

        # click DELETE and Cancel
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
        page.driver.browser.switch_to.alert.dismiss

        expect(page).to have_content 'user2'
        expect(page).to have_content 'id2'
        expect(page).to have_content '0'

        # click DELETE and OK
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_content 'user2'
        expect(page).to have_no_content 'id2'
      end
    end

    context 'visit edit_admin_user_path(user)' do
      subject { visit edit_admin_user_path(user) }

      it 'tests /tasks/edit' do
        subject
        fill_in 'user_name', with: 'user3'
        fill_in 'user_login_id', with: 'id3'
        fill_in 'user_password', with: 'password3'
        fill_in 'user_password_confirmation', with: 'password3'
        select '管理者', from: 'user_role'
        click_button '更新する'

        expect(page).to have_content 'ユーザーが更新されました！'
        expect(page).to have_content 'user3'
        expect(page).to have_content 'id3'
        expect(page).to have_content '管理者'

        # login again
        click_on 'ログアウト'
        visit login_path
        fill_in 'session_login_id', with: 'id3'
        fill_in 'session_password', with: 'password3'
        click_button 'ログイン'

        expect(page).to have_content 'task1'
        expect(page).to have_content '低'
        expect(page).to have_content '待機中'
        expect(page).to have_content '2020/12/31'

        expect(page).to have_content 'task2'
        expect(page).to have_content '中'
        expect(page).to have_content '実施中'
        expect(page).to have_content '2021/01/01'
      end
    end
  end

  describe 'authentication' do
    it 'only administrators are able to visit the admin page' do
      visit admin_users_path
      expect(page).to have_content 'TYLE(管理画面)'
      click_on 'ログアウト'

      fill_in 'session_login_id', with: user2.login_id
      fill_in 'session_password', with: 'password2'
      click_on 'ログイン'
      sleep 1

      expect(page).to have_no_content '管理画面'
      visit admin_users_path
      expect(page).to have_no_content '管理画面'
    end

    it 'the last administrator cannot change its role' do
      visit edit_admin_user_path(user)
      fill_in 'user_name', with: 'user3'
      fill_in 'user_login_id', with: 'id3'
      fill_in 'user_password', with: 'password3'
      fill_in 'user_password_confirmation', with: 'password3'
      select '一般', from: 'user_role'
      click_button '更新する'

      expect(page).to have_no_content 'ユーザーが更新されました！'
      expect(page).to have_no_content 'user3'
      expect(page).to have_no_content 'id3'
      expect(page).to have_content '編集するユーザーの詳細を入力してください'
    end

    it 'an administrator cannot delete itself' do
      visit admin_user_path(user)
      click_on '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'ユーザーの詳細'
      expect(page).to have_content 'user1'
      expect(page).to have_content 'id1'
      expect(page).to have_content '管理者'
    end
  end
end
