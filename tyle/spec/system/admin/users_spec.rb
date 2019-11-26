# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:admin_user) }
  let!(:user2) { create(:user) }

  before do
    create(:task, user_id: user.id)
    create(:task2, user_id: user.id)

    # Log in as the user in the following rspec.
    visit login_path
    fill_in 'session_login_id', with: user.login_id
    fill_in 'session_password', with: 'password1'
    click_button 'ログイン'
    sleep 1
  end

  describe 'GET #index' do
    before do
      visit admin_users_path
    end

    context 'when users exist' do
      it 'returns the user list' do
        expect(page).to have_content 'user1'
        expect(page).to have_content 'id1'
        expect(page).to have_content '管理者'
        expect(page).to have_content '2'
        expect(page).to have_content 'user2'
        expect(page).to have_content 'id2'
        expect(page).to have_content '一般'
        expect(page).to have_content '0'
      end
    end
  end

  describe 'GET #new' do
    before do
      visit new_admin_user_path
    end

    context 'when user correctly fill out the form' do
      it 'returns the created user' do
        fill_in 'user_name', with: 'user3'
        fill_in 'user_login_id', with: 'id3'
        fill_in 'user_password', with: 'password3'
        fill_in 'user_password_confirmation', with: 'password3'
        select '一般', from: 'user_role'
        click_button '登録する'

        expect(page).to have_content 'ユーザーが追加されました！'
        expect(page).to have_content 'user3'
        expect(page).to have_content 'id3'
        expect(page).to have_content '一般'
      end
    end
  end

  describe 'GET #show' do
    context 'when user visits admin_user_path(itself)' do
      before do
        visit admin_user_path(user)
      end

      context 'when a user and its tasks are correctly created' do
        it 'shows the user and its tasks' do
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

      context 'when user tries to delete itself with the delete button' do
        it 'prevents the delete with a warning message' do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_content '自分自身は削除できません'

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

      context 'when user pushes the delete button and selects No in the dialog message' do
        it 'cancels the delete' do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
          page.driver.browser.switch_to.alert.dismiss

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
    end

    context 'when user visits admin_user_path(another user)' do
      before do
        visit admin_user_path(user2)
      end

      context 'when user tries to delete another user with the delete button' do
        it 'successfully deletes the user' do
          expect(page).to have_content 'user2'
          expect(page).to have_content 'id2'
          expect(page).to have_content '一般'

          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq '本当にユーザーを削除してもいいですか？'
          page.driver.browser.switch_to.alert.accept

          expect(page).to have_no_content 'user2'
          expect(page).to have_no_content 'id2'
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user visits edit_admin_user_path(itrself)' do
      before do
        visit edit_admin_user_path(user)
      end

      context 'when user correctly fills out the form' do
        it 'updates the user info' do
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

          # It will log out, and it will log in again with the new login_id and password
          # to verify that the update has been successfully implemented.
          click_on 'ログアウト'
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

    context 'when user visit edit_admin_user_path(another_user)' do
      before do
        visit edit_admin_user_path(user2)
      end
      # TODO: I will implement a Rspec here after the user.role.admin will have been implemented.
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

      expect(page).to have_content '役割が管理者のユーザーの最後の一人は、一般ユーザーに変更できません'
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
