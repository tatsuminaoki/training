require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'When a user creates an acccount' do
    it 'Success to create an account' do
      visit new_user_path
      fill_in 'user[name]', with: 'テストユーザー'
      fill_in 'user[email]', with: 'test@example.com'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test123'
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.user.success')
    end
  end

  context 'When a user does not input name' do
    it 'Validation error shows up' do
      visit new_user_path
      fill_in 'user[email]', with: 'test@example.com'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test123'
      click_on 'commit'

      expect(page).to have_content I18n.t('error.count', count: 1)
    end
  end

  context 'When a user does not input email' do
    it 'Validation error shows up' do
      visit new_user_path
      fill_in 'user[name]', with: 'テストユーザー'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test123'
      click_on 'commit'

      expect(page).to have_content I18n.t('error.count', count: 2)
    end
  end

  context 'When a user does not input password' do
    it 'Validation error shows up' do
      visit new_user_path
      fill_in 'user[name]', with: 'テストユーザー'
      fill_in 'user[email]', with: 'hoge@example.com'
      fill_in 'user[password_confirmation]', with: 'test123'
      click_on 'commit'

      expect(page).to have_content I18n.t('error.count', count: 1)
    end
  end

  context 'When a user does not input password confirmation' do
    it 'Validation error shows up' do
      visit new_user_path
      fill_in 'user[name]', with: 'テストユーザー'
      fill_in 'user[email]', with: 'hoge@example.com'
      fill_in 'user[password]', with: 'test123'
      click_on 'commit'
  
      expect(page).to have_content I18n.t('error.count', count: 1)
    end
  end
  
  context 'When password and password_confirmation does not match' do
    it 'Validation error shows up' do
      visit new_user_path
      fill_in 'user[name]', with: 'テストユーザー'
      fill_in 'user[email]', with: 'hoge@example.com'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test1234'
      click_on 'commit'

      expect(page).to have_content I18n.t('error.count', count: 1)
    end
  end
end
