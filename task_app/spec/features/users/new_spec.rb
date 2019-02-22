# frozen_string_literal: true

require 'rails_helper'

feature '画面表示機能', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: :admin) }

  context 'タスク一覧画面からボタンクリックで画面遷移したとき' do
    before do
      login(user)
      page.find('.navbar-toggler').click
      page.find('#navbarUserMenuLink').click
      page.click_link('ユーザ登録')
    end

    scenario 'ユーザ登録画面に遷移する' do
      expect(current_path).to eq new_admin_user_path
    end
  end
end

feature 'ユーザ登録機能', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: :admin) }

  before do
    login(user, new_admin_user_path)
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    fill_in 'パスワード(確認)', with: password_confirmation
    select '管理者', from: 'user_role'
    click_on('送信')
  end

  context '正常値を入力したとき' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }

    scenario 'メッセージと共にユーザ一覧画面が表示され、ユーザ数が2であることが確認できる' do
      expect(current_path).to eq admin_users_path
      expect(page).to have_selector('.alert-success')
      expect(page).to have_selector('tr', text: 'foo@example.com')
      expect(page.all('tbody tr').size).to eq 2
    end
  end

  context '全て空欄のまま送信したとき' do
    let(:email) { '' }
    let(:password) { '' }
    let(:password_confirmation) { '' }

    scenario 'バリデーションメッセージと共に登録画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワードを入力してください')
      expect(page).to have_selector('.alert-danger', text: 'パスワードは6文字以上で入力してください')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスを入力してください')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスは不正な値です')
    end
  end

  context '誤ったメールアドレス・一致しないパスワードを入力したとき' do
    let(:email) { 'foo@example' }
    let(:password) { 'password123' }
    let(:password_confirmation) { 'password' }

    scenario 'バリデーションメッセージと共に登録画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワード(確認)とパスワードの入力が一致しません')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスは不正な値です')
    end
  end

  context '6文字以下のパスワードを入力したとき' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'pass' }
    let(:password_confirmation) { 'pass' }

    scenario 'バリデーションメッセージと共に登録画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワードは6文字以上で入力してください')
    end
  end

  context 'スペースを含むパスワードを入力したとき' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'pass word' }
    let(:password_confirmation) { 'pass word' }

    scenario 'バリデーションメッセージと共に登録画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワードにスペースを含めないでください')
    end
  end
end
