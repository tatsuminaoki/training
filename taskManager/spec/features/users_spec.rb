require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature "Users", type: :feature do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let!(:task1) { FactoryBot.create_list(:task, 10, user: user1) }
  let!(:task2) { FactoryBot.create_list(:task, 10, user: user2) }

  before do
    visit admin_users_path
    fill_in "user[mail]", with: user1.mail
    fill_in "user[password]", with: user1.password
    click_button "ログイン"
  end

  feature "ユーザの追加" do
    let(:user_params) { FactoryBot.attributes_for(:user) }
    scenario "ユーザを作成する" do
      expect {
        click_link I18n.t('actions.user_new')
        fill_in "user[user_name]", with: user_params[:user_name]
        fill_in "user[mail]", with: user_params[:mail]
        fill_in "user[password]", with: user_params[:password]
        fill_in "user[password_confirmation]", with: user_params[:password]
        click_button I18n.t('actions.new')
        expect(page).to have_content I18n.t('messages.simple_result', name: I18n.t('words.user'), action: I18n.t('actions.new'), result: I18n.t('words.success'))
        expect(page).to have_content user_params[:user_name]
        expect(page).to have_content user_params[:mail]
      }.to change(User, :count).by(1)
    end
    scenario "ユーザを変更する" do
      all(:link_or_button, I18n.t('actions.edit'))[0].click
      fill_in "user[user_name]", with: user_params[:user_name]
      fill_in "user[mail]", with: user_params[:mail]
      click_button I18n.t('actions.edit')
      expect(page).to have_content I18n.t('messages.simple_result', name: I18n.t('words.user'), action: I18n.t('actions.edit'), result: I18n.t('words.success'))
      expect(page).to have_content user_params[:user_name]
      expect(page).to have_content user_params[:mail]
    end
    scenario "ユーザを削除できること" do
      all(:link_or_button, I18n.t('actions.delete'))[1].click
      expect(page).to have_content I18n.t('messages.simple_result', name: I18n.t('words.user'), action: I18n.t('actions.delete'), result: I18n.t('words.success'))
      expect(page).not_to have_content user2.user_name
      expect(page).not_to have_content user2.mail
      expect(page).to have_content user1.user_name
      expect(page).to have_content user1.mail
    end
  end
end
