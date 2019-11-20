# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUsers', type: :system do
  let(:user) { create(:user) }
  let!(:user2) { create(:user2) }

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

    context 'when users are successfully created' do
      it 'shows the users' do
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

    context 'when you correctly fill out the form' do
      it 'shows the created user' do
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
    context 'when you visit admin_user_path(yourself)' do
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

      context 'when you try to delete yourself with the delete button' do
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

      context 'when you push the delete button and select No in the dialog message' do
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

    context 'when you visit admin_user_path(another user)' do
      before do
        visit admin_user_path(user2)
      end
      context 'when you try to delete another user with the delete button' do
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
    context 'when you visit edit_admin_user_path(yourself)' do
      before do
        visit edit_admin_user_path(user)
      end

      context 'when you correctly fill out the form' do
        it 'enables you to log in with the new login_id and the new password' do
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

          # You will log out, and you will log in again with the new login_id and password.
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

      context 'when you visit edit_admin_user_path(another_user)' do
        before do
          visit edit_admin_user_path(user2)
        end
        # TODO: I will implement a Rspec here after the user.role.admin will have been implemented.
      end
    end
  end
end
