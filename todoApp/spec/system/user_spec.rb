require 'rails_helper'

RSpec.describe 'User management', type: :system, js: true do
  context 'visit the admin_users_path' do
    before do
      User.create!(name: 'John', email: 'test@example.com', password_digest: BCrypt::Password.create('mypassword'))
      visit login_path
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'mypassword'
      click_button 'Log In'
    end

    it 'shows user lisk' do
      visit admin_users_path
      expect(page).to have_content 'test@example.com'
    end

    it 'creates a user when click New User' do
      visit admin_users_path
      click_link 'New User'
      fill_in 'Name', with: 'John2'
      fill_in 'Email', with: 'text2@example.com'
      fill_in 'Password', with: 'mypassword2'
      fill_in 'Password confirmation', with: 'mypassword2'
      click_button 'Create User'
      expect(page).to have_content 'Thank you for signing up!'
    end

    it 'updates a user when click Edit' do
      visit admin_users_path
      click_link 'Edit'
      fill_in 'Name', with: 'John5'
      fill_in 'Email', with: 'text@example.com'
      fill_in 'Password', with: 'mypassword'
      fill_in 'Password confirmation', with: 'mypassword'
      click_button 'Update User'
      expect(page).to have_content 'User was successfully updated.'
    end

    it 'Deletes the selected user when click Destroy' do
      visit admin_users_path
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).to have_current_path '/en/login'
    end
  end
end
