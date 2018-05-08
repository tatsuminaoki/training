require 'rails_helper'

RSpec.feature 'Admin', type: :feature do

  before(:each) do
    visit logout_path
    @admin = FactoryBot.create(:admin)

    visit login_path

    fill_in 'login_id', with: @admin.login_id
    fill_in 'password', with: @admin.login_id
    click_on I18n.t('buttons.login')
  end

  describe 'ユーザ登録' do
    before(:each) do
      click_on I18n.t('buttons.new')
    end

    it 'ユーザ登録ページを表示' do
      expect(page).to have_css('h1', text: I18n.t('titles.user.new'))
      expect(page).to have_selector('input', id: 'user_login_id')
      expect(page).to have_selector('input', id: 'user_password')
      expect(page).to have_selector('input', id: 'user_admin_flag')
    end

    it 'ユーザ登録成功' do
      user_attributes = FactoryBot.build(:user_attributes)
      fill_in 'user_login_id', with: user_attributes[:login_id]
      fill_in 'user_password', with: user_attributes[:password]
      click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.user'))

      expect(current_path).to eq users_path
      expect(page).to have_content user_attributes['login_id']
      # Message
      expect(page).to have_content I18n.t('notices.created', model: I18n.t('activerecord.models.user'))
    end

    it 'ユーザ登録失敗' do
      user_attributes = FactoryBot.build(:user_attributes)
      fill_in 'user_login_id', with: user_attributes[:login_id]
      fill_in 'user_password', with: ''
      click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.user'))

      # 登録ページに戻り、メッセージが表示される
      expect(page).to have_css('h1', text: I18n.t('titles.user.new'))
      expect(page).to have_content I18n.t('activerecord.errors.messages.blank')
    end
  end


  describe 'ユーザ編集' do
    before(:each) do
      @user = FactoryBot.create(:user)
      visit edit_user_path(@user.id)
    end

    it 'ユーザ編集ページを表示' do
      expect(page).to have_css('h1', text: I18n.t('titles.user.edit'))
      expect(page).to have_selector('input', id: 'user_login_id')
      expect(page).to have_selector('input', id: 'user_admin_flag')
      expect(page).to_not have_selector('input', id: 'user_password')
    end

    it 'ユーザ編集成功' do
      user_attributes = FactoryBot.build(:user_attributes)
      fill_in 'user_login_id', with: 'username'
      click_on I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.user'))

      expect(current_path).to eq user_path(@user.id)
      expect(page).to have_content user_attributes['login_id']
      # Message
      expect(page).to have_content I18n.t('notices.updated', model: I18n.t('activerecord.models.user'))
    end

    it 'ユーザ編集失敗' do
      user_attributes = FactoryBot.build(:user_attributes)
      fill_in 'user_login_id', with: ''
      click_on I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.user'))

      # 登録ページに戻り、メッセージが表示される
      expect(page).to have_css('h1', text: I18n.t('titles.user.edit'))
      expect(page).to have_content I18n.t('activerecord.errors.messages.blank')
    end
  end

  describe 'ユーザ削除' do
    before(:each) do
      @user = FactoryBot.create(:user)
      visit users_path
    end

    it 'ユーザ削除成功' do
      expect(page).to have_content @user.login_id

      find(:xpath, "//a[@href='/admin/users/#{@user.id}']").click

      expect(current_path).to eq users_path
      expect(page).to_not have_content @user.login_id
      # Message
      expect(page).to have_content I18n.t('notices.deleted', model: I18n.t('activerecord.models.user'))
    end
  end

  describe 'タスク一覧' do
    before(:each) do
      @user = FactoryBot.create(:user)
      visit users_path
    end

    it 'タスク一覧表示' do
      find(:xpath, "//a[@href='users/#{@user.id}/tasks']").click

      expect(current_path).to eq "/admin/users/#{@user.id}/tasks"
      expect(page).to have_css('h1', text: I18n.t('titles.task.list'))
    end
  end

end
