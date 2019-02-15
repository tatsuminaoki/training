# frozen_string_literal: true

require 'rails_helper'

feature '基本機能' do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }

  before do
    FactoryBot.create_list(:task, 3, user: user1)
    FactoryBot.create_list(:task, 2, user: user2)
    login(user1, admin_root_path)
  end

  feature '画面表示', type: :feature do
    context 'ログインせず画面へアクセスしたとき' do
      before do
        logout
        visit admin_root_path
      end

      scenario 'メッセージと共にログイン画面が表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_selector('.alert-danger', text: 'サービスを利用するにはログインが必要です')
        expect(page).to have_selector('form', count: 1)
      end
    end

    context 'user1でログインした状態でアクセスしたとき' do
      scenario 'ユーザ一覧画面が表示され、ユーザ数と各ユーザのタスク数を確認できる' do
        expect(current_path).to eq admin_root_path
        expect(page.all('tbody tr').size).to eq 2
        expect(page).to have_content(user1.email, count: 1)
        expect(page).to have_content(user2.email, count: 1)
        expect(page.find('tr', text: user1.email).text).to include('3')
        expect(page.find('tr', text: user2.email).text).to include('2')
      end
    end
  end

  feature 'ユーザ削除', type: :feature do
    context 'user1でログイン後、user2を削除する確認ダイアログでOKを押したとき' do
      scenario 'user2は削除され、ユーザ一覧画面にメッセージが表示される' do
        page.find('tr', text: user2.email).click_link('削除')
        page.accept_confirm
        expect(page).to have_selector '.alert-success', text: 'ユーザ「user2@example.com」を削除しました。'
        expect(page.all('tbody tr').size).to eq 1
        expect(Task.where(user_id: user2.id).count).to eq 0
      end
    end

    context 'user1でログイン後、user2を削除する確認ダイアログでキャンセルを押したとき' do
      scenario 'user2は削除されず、そのままユーザ一覧画面が表示される' do
        page.find('tr', text: user2.email).click_link('削除')
        page.dismiss_confirm
        expect(page).to have_no_selector '.alert-success', text: 'ユーザ「user2@example.com」を削除しました。'
        expect(page.all('tbody tr').size).to eq 2
        expect(page.find('tr', text: user2.email).text).to include('2')
      end
    end

    context 'user1でログイン時、自身のアカウントを削除しようとしたとき' do
      scenario 'ユーザ一覧画面に削除するリンクは存在しない' do
        expect(page.find('tr', text: user1.email)).to have_no_link('削除')
      end
    end
  end
end
