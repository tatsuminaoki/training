# frozen_string_literal: true

require 'rails_helper'

feature 'ユーザ編集機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com', role: :admin) }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com', role: :admin) }

  before do
    login(user1, admin_users_path)
    page.find('tr', text: user2.email).click_link('編集')
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    fill_in 'パスワード(確認)', with: password_confirmation
    select '一般', from: 'user_role'
    click_on('送信')
  end

  context 'メールアドレス・パスワード・権限を更新したとき(正常処理)' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'passwooord' }
    let(:password_confirmation) { 'passwooord' }

    scenario 'メッセージと共にユーザ一覧画面が表示される' do
      expect(current_path).to eq admin_users_path
      expect(page).to have_selector('.alert-success')
      expect(page).to have_selector('tr', text: 'foo@example.com')
      expect(page).to have_selector('tr', text: '一般')
      expect(page.all('tbody tr').size).to eq 2
    end
  end

  context 'メールアドレス・権限のみ更新したとき(正常処理)' do
    let(:email) { 'foo@example.com' }
    let(:password) { '' }
    let(:password_confirmation) { '' }

    scenario 'メッセージと共にユーザ一覧画面が表示される' do
      expect(current_path).to eq admin_users_path
      expect(page).to have_no_selector('.alert-danger', text: 'パスワードを入力してください') # 入力しない限りパスワードのバリデーションは実行されない
      expect(page).to have_no_selector('.alert-danger', text: 'パスワードは6文字以上で入力してください')
      expect(page).to have_selector('.alert-success')
      expect(page).to have_selector('tr', text: 'foo@example.com')
      expect(page).to have_selector('tr', text: '一般')
      expect(page.all('tbody tr').size).to eq 2
    end
  end

  context '全て空欄のまま送信したとき' do
    let(:email) { '' }
    let(:password) { '' }
    let(:password_confirmation) { '' }

    scenario 'バリデーションメッセージと共に編集画面が表示される' do
      expect(page).to have_no_selector('.alert-danger', text: 'パスワードを入力してください') # 入力しない限りパスワードのバリデーションは実行されない
      expect(page).to have_no_selector('.alert-danger', text: 'パスワードは6文字以上で入力してください')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスを入力してください')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスは不正な値です')
    end
  end

  context '誤ったメールアドレス・一致しないパスワードを入力したとき' do
    let(:email) { 'foo@example' }
    let(:password) { 'password123' }
    let(:password_confirmation) { 'password' }

    scenario 'バリデーションメッセージと共に編集画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワード(確認)とパスワードの入力が一致しません')
      expect(page).to have_selector('.alert-danger', text: 'メールアドレスは不正な値です')
    end
  end

  context '6文字以下のパスワードを入力したとき' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'pass' }
    let(:password_confirmation) { 'pass' }

    scenario 'バリデーションメッセージと共に編集画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワードは6文字以上で入力してください')
    end
  end

  context 'スペースを含むパスワードを入力したとき' do
    let(:email) { 'foo@example.com' }
    let(:password) { 'pass word' }
    let(:password_confirmation) { 'pass word' }

    scenario 'バリデーションメッセージと共に編集画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: 'パスワードにスペースを含めないでください')
    end
  end
end

feature '管理者数制御機能', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: :admin) }

  before do
    login(user, admin_users_path)
    click_on('編集')
    select '一般', from: 'user_role'
    click_on('送信')
  end

  context '管理者が1人の状態で、権限を一般に更新したとき' do
    scenario 'バリデーションメッセージと共に編集画面が表示される' do
      expect(page).to have_selector('.alert-danger', text: '管理者がいなくなる為、「権限」を更新できません')
    end
  end
end
