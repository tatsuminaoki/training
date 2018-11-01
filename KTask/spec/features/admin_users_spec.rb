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

  feature '管理ユーザーで操作' do
    background do
      user = create(:user, role: 'admin')
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      click_link I18n.t('layouts.application.user_info')
    end

    scenario 'ユーザを登録する' do
      expect do
        click_link 'ユーザ登録'
        fill_in '名前', with: '太郎'
        fill_in 'メールアドレス', with: 'taro@example.com'
        fill_in 'パスワード', with: 'password'
        click_button '登録する'
        expect(page).to have_content I18n.t('flash.user.create_success')
      end.to change { User.count }.by(1)
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

    scenario '管理者が1人もいなくなってしまう場合はユーザの削除ができない' do
      expect do
        expect(page).to have_no_content I18n.t('admin.users.index.delete')
      end.to change { User.count }.by(0)
    end

    scenario '管理者が1人もいなくなってしまうようなユーザ権限の変更はできない' do
      click_link I18n.t('admin.users.index.edit')
      expect(find('#role')).to be_disabled
    end

    feature 'ユーザが作成したタスク絡み' do
      background do
        @user1 = create(:user)
        create(:task, user_id: @user1.id)
        visit admin_users_path
      end

      scenario 'ユーザ一覧画面で、そのユーザが作成したタスクの数を表示する' do
        amounts = page.all('td.amount')
        expect(amounts[1]).to have_content '1'
      end

      scenario 'ユーザを削除する' do
        all('.delete_btn')[0].click
        expect(page).to have_content I18n.t('flash.user.delete_success')
      end

      scenario 'ユーザを削除した時、そのユーザのタスクを削除する' do
        expect do
          all('.delete_btn')[0].click
        end.to change { Task.where(user_id: @user1.id).count }.by(-1)
      end
    end
  end
end
