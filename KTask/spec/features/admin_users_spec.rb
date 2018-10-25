# frozen_string_literal: true

require 'rails_helper'
RSpec.feature 'AdminUsers', type: :feature do
  scenario '新しいユーザを作成する' do
    expect do
      visit root_path
      click_link 'ユーザ登録'
      fill_in '名前', with: 'Test user'
      fill_in 'メールアドレス', with: 'taro@example.com'
      fill_in 'パスワード', with: 'password'
      click_button '登録する'
      expect(page).to have_content 'ユーザを登録しました'
    end.to change { User.count }.by(1)
  end

  feature '既存ユーザへの操作' do
    background do
      create(:user)
      visit admin_users_path
    end

    scenario 'ユーザを更新する' do
      click_link I18n.t('admin.users.index.edit')
      fill_in '名前', with: 'after Test user'
      fill_in 'メールアドレス', with: 'changed@example.com'
      fill_in 'パスワード', with: 'password2'
      click_button '更新する'
      expect(page).to have_content I18n.t('flash.user.update_success')
      expect(page).to have_selector 'td.name', text: 'after Test user'
      expect(page).to have_selector 'td.email', text: 'changed@example.com'
    end

    scenario 'ユーザを削除する' do
      expect do
        click_link I18n.t('admin.users.index.delete')
        expect(page).to have_content 'ユーザを削除しました'
      end.to change { User.count }.by(-1)
    end
  end

  feature 'ユーザが作成したタスク絡み' do
    background do
      create(:task)
      visit admin_users_path
    end
    scenario 'ユーザを削除した時、そのユーザのタスクを削除する' do
      expect do
        click_link I18n.t('admin.users.index.delete')
      end.to change { Task.count }.by(-1)
    end
    scenario 'ユーザ一覧画面で、そのユーザが作成したタスクの数を表示する' do
      amounts = page.all('td.amount')
      expect(amounts[0]).to have_content '1'
    end
    scenario 'ユーザが作成したタスクの一覧が見れる' do
      find('.amount').click
      names = page.all('td.name')
      expect(names.count).to eq 1
    end
  end
end
