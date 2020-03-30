# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let(:admin) { FactoryBot.create(:user, name: 'admin', email: 'admin@example.com', is_admin: true) }
  let(:admin_task) { FactoryBot.create(:task, title: 'xxxxx', user: admin) }
  let(:general) { FactoryBot.create(:user, email: 'delete@example.com') }
  let(:general_task) { FactoryBot.create(:task, user: general) }

  before do |example|
    unless example.metadata[:skip_before]
      visit login_path
      fill_in 'session_email', with: admin.email
      fill_in 'session_password', with: admin.password
      click_button I18n.t('link.login')
      click_link I18n.t('link.users')
    end
  end

  describe '一覧表示' do
    it 'ユーザーが表示される' do
      expect(page).to have_content 'admin@example.com'
    end

    it '作成したタスクの数が表示される' do
      admin_task
      visit admin_users_path
      tds = page.all('td')
      expect(tds[3]).to have_content '1'
    end
  end

  describe 'タスク一覧表示' do
    it '作成したタスクが表示される' do
      admin_task
      click_link '1'
      expect(page).to have_content 'xxxxx'
    end
  end

  describe '新規作成' do
    it 'ユーザーが新規作成される' do
      visit new_admin_user_path
      fill_in 'user_name', with: '新規ユーザー'
      fill_in 'user_email', with: 'new@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button '登録する'

      expect(page).to have_content '新規ユーザー'
      expect(User.count).to eq 2
    end
  end

  describe '編集' do
    before do
      visit edit_admin_user_path(admin)
      fill_in 'user_name', with: '編集ユーザー'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
    end

    context '編集しても管理ユーザーが存在するとき' do
      it '編集できる' do
        check 'user_is_admin'
        click_button '更新する'

        expect(page).to have_content '編集ユーザー'
        expect(User.count).to eq 1
      end
    end

    context '編集すると管理ユーザーが存在しなくなるとき' do
      it '編集できない' do
        uncheck 'user_is_admin'
        click_button '更新する'

        expect(page).to have_content I18n.t('alert.admin_error')
        expect(User.count).to eq 1
      end
    end
  end

  describe '削除' do
    before do
      general
      general_task
    end

    context '削除しても管理ユーザーが存在するとき' do
      it '削除できる' do
        visit admin_user_path(general)
        click_link I18n.t('crud.delete')
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_no_content 'delete@example.com'
        expect(User.count).to eq 1
        expect(Task.count).to eq 0
      end
    end

    context '削除すると管理ユーザーが存在しなくなるとき' do
      it '削除できない' do
        visit admin_user_path(admin)
        click_link I18n.t('crud.delete')
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content I18n.t('alert.admin_error')
        expect(User.count).to eq 2
        expect(Task.count).to eq 1
      end
    end
  end

  describe 'アクセス制限' do
    it '一般ユーザーはアクセスできない', :skip_before do
      visit login_path
      fill_in 'session_email', with: general.email
      fill_in 'session_password', with: general.password
      click_button I18n.t('link.login')
      visit admin_users_path
      expect(page).to have_no_content I18n.t('headline.user.index')
      expect(page).to have_content I18n.t('headline.task.index')
    end
  end
end
