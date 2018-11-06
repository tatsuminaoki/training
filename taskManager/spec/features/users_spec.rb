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
    scenario "新しいタスクを作成する" do
      expect {
        click_link "新規登録"
        fill_in "user[user_name]", with: user_params[:user_name]
        fill_in "user[mail]", with: user_params[:mail]
        fill_in "user[password]", with: user_params[:password]
        fill_in "user[password_confirmation]", with: user_params[:password]
        click_button "登録"
        expect(page).to have_content "ユーザの新規登録が成功しました。"
        expect(page).to have_content user_params[:user_name]
        expect(page).to have_content user_params[:mail]
      }.to change(User, :count).by(1)
    end
    scenario "ユーザを変更する" do
      all(:link_or_button, "編集")[0].click
      fill_in "user[user_name]", with: user_params[:user_name]
      fill_in "user[mail]", with: user_params[:mail]
      click_button "編集"
      expect(page).to have_content "ユーザの編集が成功しました。"
      expect(page).to have_content user_params[:user_name]
      expect(page).to have_content user_params[:mail]
    end
    scenario "タスクを削除できること" do
      all(:link_or_button, "削除")[0].click
      expect(page).to have_content "ユーザの削除が成功しました。"
      expect(page).not_to have_content user1.user_name
      expect(page).not_to have_content user1.mail
      expect(page).to have_content user2.user_name
      expect(page).to have_content user2.mail
    end
  end
end
