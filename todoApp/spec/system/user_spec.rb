require 'rails_helper'

RSpec.describe 'User management', type: :system, js: true do
  context 'visit the admin_users_path' do
    before do
      User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      visit login_path
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'mypassword'
      click_button 'Log In'
    end

    it 'shows user list' do
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

    it 'ensures Name presence when creates new user.' do
      visit admin_users_path
      click_link 'New User'
      fill_in 'Email', with: 'text2@example.com'
      fill_in 'Password', with: 'mypassword2'
      fill_in 'Password confirmation', with: 'mypassword2'
      click_button 'Create User'
      expect(page).to have_content "Name can't be blank"
    end

    it 'ensures Email presence when creates new user.' do
      visit admin_users_path
      click_link 'New User'
      fill_in 'Name', with: 'John2'
      fill_in 'Password', with: 'mypassword2'
      fill_in 'Password confirmation', with: 'mypassword2'
      click_button 'Create User'
      expect(page).to have_content "Email can't be blank"
    end

    it 'ensures Password presence when creates new user.' do
      visit admin_users_path
      click_link 'New User'
      fill_in 'Name', with: 'John2'
      fill_in 'Email', with: 'text2@example.com'
      click_button 'Create User'
      expect(page).to have_content "Password can't be blank"
    end

    it 'ensures Password and confirmation should be the same when creates new user.' do
      visit admin_users_path
      click_link 'New User'
      fill_in 'Name', with: 'John2'
      fill_in 'Email', with: 'text2@example.com'
      fill_in 'Password', with: 'mypassword2'
      fill_in 'Password confirmation', with: 'mypassword8'
      click_button 'Create User'
      expect(page).to have_content "Password confirmation doesn't match Password"
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

    it 'ensures Name presence when updates the user.' do
      visit admin_users_path
      click_link 'Edit'
      fill_in 'Name', with: ''
      fill_in 'Email', with: 'text@example.com'
      fill_in 'Password', with: 'mypassword'
      fill_in 'Password confirmation', with: 'mypassword'
      click_button 'Update User'
      expect(page).to have_content "Name can't be blank"
    end

    it 'ensures Email presence when updates the user.' do
      visit admin_users_path
      click_link 'Edit'
      fill_in 'Name', with: 'John5'
      fill_in 'Email', with: ''
      fill_in 'Password', with: 'mypassword'
      fill_in 'Password confirmation', with: 'mypassword'
      click_button 'Update User'
      expect(page).to have_content "Email can't be blank"
    end

    it 'ensures Password and confirmation should be the same when updates the user.' do
      visit admin_users_path
      click_link 'Edit'
      fill_in 'Name', with: 'John5'
      fill_in 'Email', with: 'text@example.com'
      fill_in 'Password', with: 'mypassword2'
      fill_in 'Password confirmation', with: 'mypassword8'
      click_button 'Update User'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    it 'Deletes the selected user when click Destroy' do
      visit admin_users_path
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).to have_current_path '/en/login'
    end
  end

  context 'when user visit admin_users_path' do
    before do
      u1 = User.create!(name: 'John', email: 'test@example.com', password: 'mypassword')
      u2 = User.create!(name: 'Mary', email: 'test2@example.com', password: 'mypassword2')
      Task.create!(title: 'user1 task', user_id: u1.id)
      Task.create!(title: 'user1 task2', user_id: u1.id)
      Task.create!(title: 'user2 task', user_id: u2.id)
      visit login_path
      fill_in 'email', with: 'test@example.com'
      fill_in 'password', with: 'mypassword'
      click_button 'Log In'
    end

    it 'shows number of task that user has' do
      visit admin_users_path
      num_of_task = find(:xpath, ".//table/tbody/tr[1]/td[3]").text
      expect(num_of_task).to have_content '2'
    end
  end
end
