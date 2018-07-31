# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'AdminUsers', type: :feature do
  scenario '新しいユーザを作成する' do
    expect do
      visit root_path
      click_link 'ユーザ一覧'
      click_link '新規ユーザ登録'
      fill_in '名前', with: '太郎'
      fill_in 'メールアドレス', with: 'taro@example.com'
      fill_in 'パスワード', with: 'password'
      click_button '登録する'
      expect(page).to have_content 'ユーザを作成しました'
    end.to change { User.count }.by(1)
  end

  feature '既存ユーザへの操作' do
    background do
      create(:user)
      visit admin_users_path
    end

    scenario 'ユーザを編集する' do
      find('.edit-btn').click
      fill_in '名前', with: '変更後名前'
      fill_in 'メールアドレス', with: 'changed@example.com'
      fill_in 'パスワード', with: 'password2'
      click_button '更新する'
      expect(page).to have_content 'ユーザを編集しました'
      expect(page).to have_selector 'td.name', text: '変更後名前'
      expect(page).to have_selector 'td.email', text: 'changed@example.com'
    end

    scenario 'ユーザを削除する' do
      expect do
        find('.delete-btn').click
        expect(page).to have_content 'ユーザを削除しました'
      end.to change { User.count }.by(-1)
    end
  end

  feature 'ユーザが作成したタスク絡み' do
    background do
      create(:task)
      visit admin_users_path
    end

    scenario 'ユーザを削除したら、そのユーザの抱えているタスクを削除する' do
      expect do
        find('.delete-btn').click
      end.to change { Task.count }.by(-1)
    end

    scenario 'ユーザ一覧画面で、そのユーザが抱えているタスクの数を表示する' do
      amounts = page.all('td.amount')
      expect(amounts[0]).to have_content '1'
    end

    scenario 'ユーザが作成したタスクの一覧が見れる' do
      find('.amount-btn').click
      names = page.all('td.name')
      expect(names.count).to eq 1
    end
  end
end
