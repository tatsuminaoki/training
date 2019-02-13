# frozen_string_literal: true

require 'rails_helper'

feature 'ログイン画面', type: :feature do
  before { visit login_path }

  feature '画面へのアクセス' do
    context '非ログイン状態でアクセスしたとき' do
      scenario 'ログイン画面が表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_selector('nav', text: 'TaskApp')
        expect(page).to have_no_selector('button.navbar-toggler')
        expect(page).to have_selector('form', count: 1)
      end
    end

    context 'ログイン状態でアクセスしたとき' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        login(user)
        visit login_path
      end

      scenario 'タスク一覧画面が表示される' do
        expect(current_path).to eq root_path
        expect(page).to have_selector('table', count: 1)
      end
    end
  end

  feature 'ログイン処理' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      fill_in 'session_email',    with: email
      fill_in 'session_password', with: password
      click_on('ログイン')
    end

    shared_examples 'ログイン画面が表示される' do
      scenario 'メッセージと共にログイン画面が再表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_selector('.alert-danger', text: 'メールアドレスまたはパスワードが正しくありません')
      end
    end

    context '正しい情報を入力したとき' do
      let(:email) { 'test@example.com' }
      let(:password) { 'password' }

      scenario 'タスク一覧画面が表示される' do
        expect(current_path).to eq root_path
        expect(page).to have_selector('button.navbar-toggler')
        expect(page).to have_selector('.alert-success', text: 'ログインしました')
      end
    end

    context 'メールアドレス・パスワード共に空欄のとき' do
      let(:email) { '' }
      let(:password) { '' }

      it_behaves_like 'ログイン画面が表示される'
    end

    context 'メールアドレスの入力を誤ったとき' do
      let(:email) { 'test123@example.com' }
      let(:password) { 'password' }

      it_behaves_like 'ログイン画面が表示される'
    end

    context 'パスワードの入力を誤ったとき' do
      let(:email) { 'test@example.com' }
      let(:password) { 'password123' }

      it_behaves_like 'ログイン画面が表示される'
    end
  end
end
