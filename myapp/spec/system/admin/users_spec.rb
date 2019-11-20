require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
    @user = create(:user)
    @task = create_list(:task, 10, user_id: @user.id)
    login(@user)
  end

  context 'When a user opens user list' do
    it 'Success to show an user list' do
      visit admin_users_path

      expect(page).to have_content @user.name
      expect(page).to have_content @user.email
      expect(page).to have_content 10
      expect(page).to have_link 'user_show', href: admin_user_path(@user.id)
      expect(page).to have_link 'user_edit', href: edit_admin_user_path(@user.id)
      expect(page).to have_link 'user_delete', href: admin_user_path(@user.id)
    end
  end

  context 'When a user opens detail user information page' do
    it 'Show user name, email, created_at and tasks' do
      visit admin_user_path(@user.id)

      expect(page).to have_content @user.name
      expect(page).to have_content @user.email
      expect(page).to have_content @user.created_at.strftime("%Y-%m-%d %H:%M")
      expect(page).to have_link 'user_edit', href: edit_admin_user_path(@user.id)
      expect(page).to have_link 'user_delete', href: admin_user_path(@user.id)
    end
  end

  context 'When a user tries to edit an user information' do
    it 'Success to update an user information' do
      visit edit_admin_user_path(@user.id)
      fill_in 'user[name]', with: 'テスト太郎'
      fill_in 'user[email]', with: 'test.taro@example.com'
      click_on '更新する'

      expect(page).to have_content '更新しました。'
    end
  end

  context 'When a user deletes the other user on user list page' do
    it 'Success to delete user' do
      visit admin_users_path
      click_on 'user_delete'

      expect(page).to have_content '削除しました。'
    end
  end

  context 'When a user deletes the other user on user detail page' do
    it 'Success to delete user' do
      visit admin_user_path(@user.id)
      click_on 'user_delete'

      expect(page).to have_content '削除しました。'
    end
  end

  context 'When there is validation error' do
    it 'Fail to update a user because of the length of name' do
      visit edit_admin_user_path(@user.id)
      fill_in 'user[name]', with: 'テ' * 33
      fill_in 'user[email]', with: 'test.taro@example.com'
      click_on '更新する'

      expect(page).to have_content '更新に失敗しました。もう一度お試しください。'
      expect(page).to have_content '1件のエラーがあります。'
      expect(page).to have_content 'ユーザ名は32文字以内で入力してください'
    end

    it 'Fail to update a user because empty name' do
      visit edit_admin_user_path(@user.id)
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: 'test.taro@example.com'
      click_on '更新する'

      expect(page).to have_content '更新に失敗しました。もう一度お試しください。'
      expect(page).to have_content '1件のエラーがあります。'
      expect(page).to have_content 'ユーザ名を入力してください'
    end

    it 'Fail to update a user because of the format of email' do
      visit edit_admin_user_path(@user.id)
      fill_in 'user[name]', with: 'テスト'
      fill_in 'user[email]', with: 'test'
      click_on '更新する'

      expect(page).to have_content '更新に失敗しました。もう一度お試しください。'
      expect(page).to have_content '1件のエラーがあります。'
      expect(page).to have_content 'メールアドレスは不正な値です'
    end

    it 'Fail to update a user because empty email' do
      visit edit_admin_user_path(@user.id)
      fill_in 'user[name]', with: 'テスト'
      fill_in 'user[email]', with: ''
      click_on '更新する'

      expect(page).to have_content '更新に失敗しました。もう一度お試しください。'
      expect(page).to have_content '2件のエラーがあります。'
      expect(page).to have_content 'メールアドレスを入力してください'
    end
  end
end
