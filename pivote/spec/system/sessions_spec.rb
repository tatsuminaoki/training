# frozen_string_literal: true

require 'rails_helper'

describe 'ログイン機能', type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe 'ログイン' do
    before do
      visit login_path
      fill_in 'session_email', with: email
      fill_in 'session_password', with: password
      click_button 'ログイン'
    end

    context '正常な値を入力したとき' do
      let(:email) { user.email }
      let(:password) { user.password }

      it 'ログインできる' do
        expect(page).to have_content I18n.t('flash.login')
      end
    end

    context 'メールアドレスを間違えたとき' do
      let(:email) { 'hogegege@example.com' }
      let(:password) { user.password }

      it 'ログインできない' do
        expect(page).to have_content I18n.t('alert.login_error')
      end
    end

    context 'パスワードを間違えたとき' do
      let(:email) { user.email }
      let(:password) { 'hogegege' }

      it 'ログインできない' do
        expect(page).to have_content I18n.t('alert.login_error')
      end
    end
  end

  describe 'ログアウト' do
    context 'ログイン状態のとき' do
      before do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
      end

      it 'ログアウトできる' do
        click_link I18n.t('link.logout')
        expect(page).to have_content I18n.t('flash.logout')
      end
    end
  end
end
