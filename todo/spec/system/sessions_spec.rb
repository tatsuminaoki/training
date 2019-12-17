# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'when log in' do
    let!(:user) { create(:user) }
    context 'with valid attribute' do
      it 'success' do
        visit login_path
        log_in_as(user)
        expect(page.current_path).to eq('/tasks')
      end
    end

    context 'with invalid attribute' do
      it 'failed for no name' do
        visit login_path
        fill_in 'session_password', with: 'test_password'
        click_on 'ログイン'
        expect(page).to have_content '名前またはユーザ名が誤っています'
      end

      it 'failed for no password' do
        visit login_path
        fill_in 'session_name', with: 'test_user'
        click_on 'ログイン'
        expect(page).to have_content '名前またはユーザ名が誤っています'
      end

      it 'failed for wrong password' do
        visit login_path
        fill_in 'session_name', with: 'test_user'
        fill_in 'session_password', with: 'wrong_password'
        click_on 'ログイン'
        expect(page).to have_content '名前またはユーザ名が誤っています'
      end
    end
  end

  describe 'when log out' do
    let!(:user) { create(:user) }
    context 'with logged-in user' do
      it 'success' do
        visit login_path
        fill_in 'session_name', with: 'test_user'
        fill_in 'session_password', with: 'test_password'
        click_on 'ログイン'
        expect(page.current_path).to eq('/tasks')

        click_on 'Log out'
        expect(page.current_path).to eq('/login')

        # ログインしていない状態で/tasksには行かない
        visit tasks_path
        expect(page.current_path).to eq('/login')
      end
    end
  end
end
