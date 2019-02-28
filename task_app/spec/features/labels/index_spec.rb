# frozen_string_literal: true

require 'rails_helper'

feature 'ラベル一覧画面', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  before { login(user) }

  feature '画面表示機能', type: :feature do
    let!(:label) { FactoryBot.create(:label, user: user) }
    let!(:other_user) { FactoryBot.create(:user, email: 'otheruser@example.com') }
    let!(:other_user_label) { FactoryBot.create(:label, name: 'other_user', user: other_user) }

    context 'ログインせず画面へアクセスしたとき' do
      before { logout(labels_path) }

      scenario 'メッセージと共にログイン画面が表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_selector('.alert-danger', text: 'サービスを利用するにはログインが必要です')
        expect(page).to have_selector('form', count: 1)
      end
    end

    context 'ログイン状態でアクセスしたとき' do
      before { visit labels_path }

      scenario 'ラベル一覧画面が表示され、ログインユーザのラベルを確認できる。他のユーザのラベルは確認できない。' do
        expect(page.all('tbody tr').size).to eq 1
        expect(page).to have_content label.name
        expect(page).to have_no_content other_user_label.name
      end
    end
  end

  feature 'ラベル削除機能' do
    let!(:label) { FactoryBot.create(:label, user: user) }

    before do
      visit labels_path
      click_on('削除')
    end

    context '確認ダイアログでOKを押したとき' do
      scenario 'ラベルは削除され、一覧画面にメッセージが表示される' do
        page.accept_confirm
        expect(page).to have_selector '.alert-success', text: 'ラベル「テストラベル」を削除しました。'
        expect(page.all('tbody tr').size).to eq 0
        expect(Label.count).to eq 0
      end
    end

    context '確認ダイアログでキャンセルを押したとき' do
      scenario 'ラベルは削除されず、そのまま一覧画面が表示される' do
        page.dismiss_confirm
        expect(page).to have_no_selector '.alert-success', text: 'ラベル「テストラベル」を削除しました。'
        expect(page.all('tbody tr').size).to eq 1
        expect(Label.count).to eq 1
      end
    end
  end

  feature 'ページネーション機能' do
    before do
      10.times { |i| FactoryBot.create(:label, name: "ラベル#{i}", user: user) }
      visit labels_path
    end

    context 'ラベル数が10のとき' do
      scenario '1ページ目に6ラベルが表示される' do
        expect(page).to have_content '全10件中1 - 6件のラベルが表示されています'
        expect(page).to have_link '次 ›'
        expect(page).to have_no_link '‹ 前'
        expect(page.all('tbody tr').size).to eq 6
      end

      scenario '2ページ目に4ラベルが表示される' do
        find_link('次').click
        expect(page).to have_content '全10件中7 - 10件のラベルが表示されています'
        expect(page).to have_link '‹ 前'
        expect(page).to have_no_link '次 ›'
        expect(page.all('tbody tr').size).to eq 4
      end
    end
  end
end
