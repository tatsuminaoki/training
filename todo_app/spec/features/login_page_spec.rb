# frozen_string_literal: true

require 'rails_helper'

shared_examples 'ログイン画面のメッセージ確認' do
  it 'エラーメッセージが表示されること' do
    expect(page).to have_css('.form-signin')
    expect(page).to have_content(I18n.t('errors.messages.invalid_login'))
  end
end

describe 'ログイン画面', type: :feature do
  before { visit login_path }

  describe '画面表示の検証' do
    it 'ログイン画面が表示できること' do
      expect(page).to have_css('.form-signin')
      expect(page).to have_content(I18n.t('page.login.labels.title', app_name: I18n.t('page.common.app_name')))
      expect(page).to have_selector('#sessions_name')
      expect(page).to have_selector('#sessions_password')
    end
  end

  describe 'ログイン処理の検証' do
    before do
      fill_in I18n.t('page.login.labels.user_name'), with: name
      fill_in I18n.t('page.login.labels.password'), with: password
      click_on I18n.t('page.common.login')
    end

    context 'ログインに成功する場合' do
      let(:user) { create(:user) }
      let(:name) { user.name }
      let(:password) { user.password }

      it 'ユーザー名、パスワードを入力してログイン後、タスク一覧画面に遷移すること' do
        expect(page).to have_css('#todo_app_task_list')
      end
    end

    context 'ログインに失敗する場合' do
      context '存在しないユーザーの場合' do
        let(:name) { 'someone' }
        let(:password) { 'somepassword' }

        it_behaves_like 'ログイン画面のメッセージ確認'
      end

      context '存在するユーザーのユーザー名を間違えた場合' do
        let(:user) { create(:user) }
        let(:name) { user.name + 'a' }
        let(:password) { user.password }

        it_behaves_like 'ログイン画面のメッセージ確認'
      end

      context '存在するユーザーのパスワードを間違えた場合' do
        let(:user) { create(:user) }
        let(:name) { user.name }
        let(:password) { user.password + 'a' }

        it_behaves_like 'ログイン画面のメッセージ確認'
      end

      context '存在するユーザーのパスワードが空白の場合' do
        let(:user) { create(:user) }
        let(:name) { user.name }
        let(:password) { nil }

        it_behaves_like 'ログイン画面のメッセージ確認'
      end
    end
  end
end
