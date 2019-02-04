# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'ユーザ管理画面', type: :feature do
  let!(:admin_user) { create(:user, name: 'admin_user_1', auth_level: :admin) }
  let!(:other_users) { create_list(:user, 3) }
  let!(:tasks) { create_list(:task, 3, user: admin_user) }
  before do
    visit root_path
    fill_in 'user[email]', with: admin_user.email
    fill_in 'user[password]', with: admin_user.password
    click_button 'ログイン'
  end
  context '初期表示' do
    scenario 'ユーザ一覧の表示確認' do
      visit admin_users_path
      expect(User.count).to eq(4)
      expect(page).to have_content admin_user.name
      expect(page).to have_content admin_user.email
      expect(page).to have_content admin_user.tasks.count
      other_users.each do |user|
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content user.tasks.count
      end
    end
  end
end
RSpec.feature 'ユーザ管理 機能テスト(遷移・更新系)', type: :feature do
  let!(:admin_user) { create(:user, name: 'admin_user_1', auth_level: :admin) }
  before do
    visit root_path
    fill_in 'user[email]', with: admin_user.email
    fill_in 'user[password]', with: admin_user.password
    click_button 'ログイン'
  end
  context '画面遷移テスト' do
    scenario 'ユーザ登録画面への遷移確認' do
      visit admin_users_path
      click_on('ユーザ管理')
      click_on('ユーザ登録')
      expect(current_path).to eq new_admin_user_path
      expect(page).to have_field 'user_name', with: ''
      expect(page).to have_field 'user_email', with: ''
    end
    scenario 'ユーザの更新画面への遷移確認' do
      visit admin_users_path
      click_link '編集', match: :first
      expect(current_path).to eq edit_admin_user_path(admin_user)
      expect(page).to have_field 'user_name', with: admin_user.name
      expect(page).to have_field 'user_email', with: admin_user.email
    end
  end
  context '登録・更新・削除テスト' do
    let!(:other_user) { create(:user) }
    let(:added_user) { build(:user) }
    let(:updated_user) { build(:user) }
    scenario 'ユーザの登録確認' do
      visit new_admin_user_path
      expect {
        fill_in 'user_name', with: added_user.name
        fill_in 'user_email', with: added_user.email
        fill_in 'user_password', with: 'new password'
        fill_in 'user_password_confirmation', with: 'new password'
        click_on('登録')
      }.to change { User.count }.by(1)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'ユーザの登録に成功しました。'
      expect(page).to have_content added_user.name
      expect(page).to have_content added_user.email
    end
    scenario 'ユーザの更新確認（更新対象が自身以外の場合）' do
      visit edit_admin_user_path(other_user)
      expect {
        fill_in 'user_name', with: updated_user.name
        fill_in 'user_email', with: updated_user.email
        select '一般', from: 'user_auth_level'
        click_on('更新')
      }.to change { User.count }.by(0)
      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'ユーザの更新に成功しました。'
      expect(page).to_not have_content other_user.name
      expect(page).to_not have_content other_user.email
      expect(page).to have_content updated_user.name
      expect(page).to have_content updated_user.email
      other_user.reload
      expect(other_user.name).to eq updated_user.name
      expect(other_user.email).to eq updated_user.email
    end
    scenario 'ユーザの更新制限確認（更新対象が自身の場合）権限を一般に変更できないこと' do
      visit edit_admin_user_path(admin_user)
      expect {
        fill_in 'user_name', with: updated_user.name
        fill_in 'user_email', with: updated_user.email
        select '一般', from: 'user_auth_level'
        click_on('更新')
      }.to change { User.count }.by(0)
      expect(page).to have_content 'ユーザの更新に失敗しました。'
    end
    scenario 'ユーザの削除確認（削除対象が自身以外の場合）' do
      visit admin_users_path
      expect {
        page.all('.delete')[0].click
        page.accept_confirm "#{other_user.name}を削除しますか？"
        expect(current_path).to eq admin_users_path
      }.to change { User.count }.by(-1)
      expect(page).to have_content 'ユーザの削除に成功しました。'
    end
    scenario 'ユーザの削除制限確認（自身が対象の場合）' do
      visit admin_users_path
      expect {
        page.all('.delete')[1].click
        page.accept_confirm "#{admin_user.name}を削除しますか？"
        expect(current_path).to eq admin_users_path
      }.to change { User.count }.by(0)
      expect(page).to have_content 'ユーザの削除に失敗しました。'
    end
  end
end
RSpec.feature 'ユーザ管理 機能テスト(ページング)', type: :feature do
  let!(:admin_user) { create(:user, auth_level: :admin) }
  before do
    visit admin_users_path
    fill_in 'user[email]', with: admin_user.email
    fill_in 'user[password]', with: admin_user.password
    click_button 'ログイン'
  end
  context '1ページ目のみ（ユーザ1件）の時' do
    scenario 'ページングが表示されないこと' do
      visit admin_users_path
      expect(User.all.size).to eq(1)
      expect(page.all('td.name').count).to eq 1
      expect(page).not_to have_selector('.pagination')
    end
  end
  context '1ページ目のみ（ユーザ5件）の時' do
    let!(:users) { create_list(:user, 4) }
    scenario 'ページングが表示されないこと' do
      visit admin_users_path
      expect(User.all.size).to eq(5)
      expect(page.all('td.name').count).to eq 5
      expect(page).not_to have_selector('.pagination')
    end
  end
  context '2ページ分（ユーザ10件）のユーザがある時' do
    let!(:users) { create_list(:user, 9) }
    scenario '1ページ目のページングが適切に表示されること' do
      visit admin_users_path
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to_not have_content '« 最初'
      expect(page).to_not have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
    end
    scenario '2ページ目のページングが適切に表示されること' do
      visit admin_users_path(page: 2)
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to_not have_content '次 ›'
      expect(page).to_not have_content '最後 »'
    end
  end
  context '3ページ分（ユーザ12件）のユーザがある時' do
    let!(:users) { 11.times { |i| create(:user, name: "User Name #{i}") } }
    scenario '1ページ目のページングが適切に表示されること' do
      visit admin_users_path
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to_not have_content '« 最初'
      expect(page).to_not have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
      expect(page.all('td.name').count).to eq 5
      10.downto(6) { |i| expect(page).to have_content("User Name #{i}", count: 1) }
    end
    scenario '2ページ目のページングが適切に表示されること' do
      visit admin_users_path(page: 2)
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
      expect(page.all('td.name').count).to eq 5
      5.downto(1) { |i| expect(page).to have_content("User Name #{i}", count: 1) }
    end
    scenario '3ページ目のページングが適切に表示されること' do
      visit admin_users_path(page: 3)
      expect(page.all('td.name').count).to eq 2
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to_not have_content '次 ›'
      expect(page).to_not have_content '最後 »'
      expect(page.all('td.name').count).to eq 2
      expect(page).to have_content 'User Name 0'
      expect(page).to have_content admin_user.name
    end
    scenario '1ページ目の「2」リンクで2ページ目に遷移できること' do
      visit admin_users_path
      find(:css, '.page-item > a', text: '2').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 2)
    end
    scenario '1ページ目の「次」リンクで2ページ目に遷移できること' do
      visit admin_users_path
      find(:css, '.page-item > a', text: '次').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 2)
    end
    scenario '1ページ目の「最後」リンクで3ページ目に遷移できること' do
      visit admin_users_path
      find(:css, '.page-item > a', text: '最後').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 3)
    end
    scenario '2ページ目の「最初」リンクで1ページ目に遷移できること' do
      visit admin_users_path(page: 2)
      find(:css, '.page-item > a', text: '最初').click
      expect(current_path).to eq admin_users_path
    end
    scenario '2ページ目の「前」リンクで1ページ目に遷移できること' do
      visit admin_users_path(page: 2)
      find(:css, '.page-item > a', text: '前').click
      expect(current_path).to eq admin_users_path
    end
    scenario '2ページ目の「次」リンクで3ページ目に遷移できること' do
      visit admin_users_path(page: 2)
      find(:css, '.page-item > a', text: '次').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 3)
    end
    scenario '2ページ目の「最後」リンクで3ページ目に遷移できること' do
      visit admin_users_path(page: 2)
      find(:css, '.page-item > a', text: '最後').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 3)
    end
    scenario '3ページ目の「最初」リンクで1ページ目に遷移できること' do
      visit admin_users_path(page: 3)
      find(:css, '.page-item > a', text: '最初').click
      expect(current_path).to eq admin_users_path
    end
    scenario '3ページ目の「前」リンクで2ページ目に遷移できること' do
      visit admin_users_path(page: 3)
      find(:css, '.page-item > a', text: '前').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq admin_users_path(page: 2)
    end
  end
end
