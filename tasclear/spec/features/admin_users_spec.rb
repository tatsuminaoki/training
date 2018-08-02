# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'AdminUsers', type: :feature do
  feature '管理ユーザーで操作' do
    background do
      user = create(:user, role: 'admin')
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      click_link 'ユーザ一覧'
    end

    scenario '新しいユーザを作成する' do
      expect do
        click_link '新規ユーザ登録'
        fill_in '名前', with: '太郎'
        fill_in 'メールアドレス', with: 'taro@example.com'
        fill_in 'パスワード', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'ユーザを作成しました'
      end.to change { User.count }.by(1)
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

    scenario '管理ユーザが1人もいなくなってしまう場合はユーザの削除ができない' do
      expect do
        find('.delete-btn').click
        expect(page).to have_content '少なくとも1人の管理ユーザが必要です'
      end.to change { User.count }.by(0)
    end

    scenario '管理ユーザが1人もいなくなってしまうようなユーザ種別の編集はできない' do
      find('.edit-btn').click
      select '一般ユーザ', from: 'ユーザ種類'
      fill_in 'パスワード', with: 'password'
      click_button '更新する'
      expect(page).to have_content '少なくとも1人の管理ユーザが必要です'
    end

    feature '別ユーザへの操作' do
      background do
        create(:user)
        visit admin_users_path
      end

      scenario '管理ユーザが0人にならない場合はユーザが削除できる' do
        expect do
          all('.delete-btn')[1].click
          expect(page).to have_content 'ユーザを削除しました'
        end.to change { User.count }.by(-1)
      end
    end

    feature 'ユーザが作成したタスク絡み' do
      background do
        @user1 = create(:user)
        create(:task, user_id: @user1.id)
        visit admin_users_path
      end

      scenario 'ユーザを削除したら、そのユーザの抱えているタスクを削除する' do
        expect do
          all('.delete-btn')[1].click
        end.to change { Task.where(user_id: @user1.id).count }.by(-1)
      end
    end

    feature '管理ユーザを作成' do
      background do
        create(:user, role: 'admin')
        visit admin_users_path
      end

      scenario '自分自身を削除できる' do
        expect do
          all('.delete-btn')[0].click
          expect(page).to have_current_path '/sessions/new'
        end.to change { User.count }.by(-1)
      end
    end

    feature '2名以上のユーザ作成' do
      background do
        @user1 = create(:user)
        create(:task, name: 'ユーザ1のタスク', user_id: @user1.id)
        @user2 = create(:user)
        create(:task, name: 'ユーザ2のタスク1', user_id: @user2.id)
        create(:task, name: 'ユーザ2のタスク2', user_id: @user2.id)
        visit admin_users_path
      end

      scenario 'ユーザ一覧画面で、そのユーザが抱えているタスクの数を表示する' do
        amounts = page.all('td.amount')
        expect(amounts[1]).to have_content '1'
        expect(amounts[2]).to have_content '2'
      end

      scenario 'ユーザが作成したタスクの一覧が見れる' do
        all('.amount-btn')[1].click
        expect(page).to have_content 'ユーザ1のタスク'
        expect(page).not_to have_content 'ユーザ2のタスク1'
        expect(page).not_to have_content 'ユーザ2のタスク2'
        visit admin_users_path
        all('.amount-btn')[2].click
        expect(page).not_to have_content 'ユーザ1のタスク'
        expect(page).to have_content 'ユーザ2のタスク1'
        expect(page).to have_content 'ユーザ2のタスク2'
      end
    end
  end

  feature '一般ユーザーで操作' do
    background do
      user = create(:user, role: 'general')
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    scenario '一般ユーザではユーザ一覧画面にアクセスできない' do
      visit admin_users_path
      expect(page).to have_content '権限がありません'
      expect(page).to have_current_path '/'
    end
  end
end
