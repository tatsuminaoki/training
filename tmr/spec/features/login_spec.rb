require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do

  before(:each) do
    visit logout_path
    @user = FactoryBot.create(:user)
  end

  describe 'ログイン' do
    it 'ログインページを表示' do
      visit login_path
      expect(page).to have_css('h1', text: I18n.t('titles.login.login'))
      expect(page).to have_selector('input', id: 'login_id')
      expect(page).to have_selector('input', id: 'password')
    end

    it 'ログイン' do
      visit login_path

      fill_in 'login_id', with: @user.login_id
      fill_in 'password', with: @user.login_id
      click_on I18n.t('buttons.login')

      # タスクリストを表示
      expect(page).to have_css('h1', text: I18n.t('titles.task.list'))
    end

    it '管理者ログイン' do
      @user.update({admin_flag: true})
      visit login_path

      fill_in 'login_id', with: @user.login_id
      fill_in 'password', with: @user.login_id
      click_on I18n.t('buttons.login')

      # ユーザリストを表示
      expect(page).to have_css('h1', text: I18n.t('titles.user.list'))
    end
  end

  describe 'ユーザ登録' do
    it 'ユーザ登録ページを表示' do
      visit signup_path
      expect(page).to have_css('h1', text: I18n.t('titles.login.signup'))
      expect(page).to have_selector('input', id: 'login_id')
      expect(page).to have_selector('input', id: 'password')
    end

    it 'ユーザ登録成功' do
      # 重複エラーになるので一旦削除する
      @user.destroy
      visit signup_path

      fill_in 'login_id', with: @user.login_id
      fill_in 'password', with: @user.login_id
      click_on I18n.t('buttons.signup')

      expect(page).to have_css('h1', text: I18n.t('titles.task.list'))
    end

    it 'ユーザ登録失敗' do
      visit signup_path

      fill_in 'login_id', with: @user.login_id
      fill_in 'password', with: nil
      click_on I18n.t('buttons.signup')

      # 登録ページに戻り、メッセージが表示される
      expect(page).to have_css('h1', text: I18n.t('titles.login.signup'))
      expect(page).to have_content I18n.t('activerecord.errors.messages.blank')
    end
  end

  describe 'ログアウト' do
    before do
      visit login_path

      fill_in 'login_id', with: @user.login_id
      fill_in 'password', with: @user.login_id
      click_on I18n.t('buttons.login')
    end

    it 'ログアウト' do
      visit logout_path

      # ログインページが表示される
      expect(page).to have_css('h1', text: I18n.t('titles.login.login'))
      expect(page).to have_selector('input', id: 'login_id')
      expect(page).to have_selector('input', id: 'password')
    end
  end

end
