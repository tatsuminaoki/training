# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '新規ユーザ登録', type: :feature do
  let!(:init_user) { build(:user) }
  context '新規ユーザ登録への画面遷移' do
    scenario 'ユーザ情報登録画面が表示されること' do
      visit root_path
      click_link '新規ユーザ登録'
      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content('ユーザ情報の登録')
    end
  end
  context '新規ユーザ登録処理' do
    scenario '正しくユーザ登録できること' do
      visit new_user_registration_path
      expect {
        fill_in 'user[email]', with: init_user.email
        fill_in 'user[name]', with: init_user.name
        fill_in 'user[password]', with: init_user.password
        fill_in 'user[password_confirmation]', with: init_user.password
        click_button '登録'
      }.to change { User.count }.by(1)
      expect(current_path).to eq root_path()
      expect(page).to have_content("#{init_user.name}さんのタスク")
    end
  end
end
RSpec.feature 'ログイン前テスト', type: :feature do
  let!(:init_user) { create(:user) }
  context 'ログイン画面表示' do
    scenario 'ログイン画面が表示されること' do
      visit root_path
      expect(page).to have_content('アカウント登録もしくはログインしてください。')
      visit tasks_path
      expect(page).to have_content('アカウント登録もしくはログインしてください。')
      visit new_task_path
      expect(page).to have_content('アカウント登録もしくはログインしてください。')
    end
  end
  context 'ログイン処理' do
    scenario '正しくログインできること' do
      visit root_path
      fill_in 'user[email]', with: init_user.email
      fill_in 'user[password]', with: init_user.password
      click_button 'ログイン'
      expect(current_path).to eq root_path()
      expect(page).to have_content("#{init_user.name}さんのタスク")
    end
  end
end
RSpec.feature 'ログイン後テスト', type: :feature do
  let!(:init_user) { create(:user) }
  before do
    visit root_path
    fill_in 'user[email]', with: init_user.email
    fill_in 'user[password]', with: init_user.password
    click_button 'ログイン'
  end
  context 'タスク一覧画面' do
    let!(:other_user) { create(:user) }
    let!(:my_tasks) { create_list(:task, 12, name: 'My Task Name', user: init_user) }
    let!(:other_tasks) { create_list(:task, 12, name: 'Other Task Name', user: other_user) }
    scenario '自分のタスクのみが表示されること' do
      visit tasks_path
      expect(page).to have_content("#{init_user.name}さんのタスク")
      expect(page).not_to have_content("#{other_user.name}さんのタスク")
      expect(page).to have_content('My Task Name')
      expect(page).not_to have_content('Other Task Name')
    end
    scenario '自分のタスク詳細にアクセスできること' do
      my_tasks.each do |my_task|
        visit task_path(my_task)
        expect(page).to have_content 'タスクの詳細'
        expect(page).to have_content my_task.name
        expect(page).to have_content my_task.description
      end
    end
    scenario '他人のタスク詳細にアクセスできないこと' do
      other_tasks.each do |other_task|
        visit task_path(other_task)
        expect(page).to have_content('ページが見つかりませんでした')
      end
    end
  end
  context 'ユーザ情報更新画面' do
    let!(:updated_user) { build(:user) }
    scenario 'ユーザ情報を更新できること' do
      visit edit_user_registration_path
      expect {
        fill_in 'user[email]', with: updated_user.email
        fill_in 'user[name]', with: updated_user.name
        fill_in 'user[password]', with: updated_user.password
        fill_in 'user[password_confirmation]', with: updated_user.password
        fill_in 'user[current_password]', with: init_user.password
        click_button '更新'
      }.to change { User.count }.by(0)
      expect(page).to have_content("#{updated_user.name}さんのタスク")
      expect(page).not_to have_content("#{init_user.name}さんのタスク")
    end
  end
end
