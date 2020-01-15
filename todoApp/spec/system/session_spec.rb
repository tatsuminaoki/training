require 'rails_helper'

RSpec.describe 'Auth management', type: :system, js: true do

  context 'when user login / logout' do
    before do
      User.create!(name: 'John', email: 'test@example.com', password_digest: BCrypt::Password.create('mypassword'))
    end

    it 'should be login / logout success with correct account infomation' do
      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
      expect(page).to have_content 'Logged in!'
      
      expect(page).to have_link 'Log Out'
      click_link 'Log Out'
      expect(page).to have_content 'Logged out!'
    end

    it 'should be failed with non-exist email' do
      visit login_path
      fill_in 'Email', with: :'non-exist@example.com'
      fill_in 'Password', with: :'mypassword'
      click_button 'Log In'
      expect(page).to have_content 'Email or password is invalid'
    end

    it 'should be failed with incorrect password' do
      visit login_path
      fill_in 'Email', with: :'test@example.com'
      fill_in 'Password', with: :'wrongpassword'
      click_button 'Log In'
      expect(page).to have_content 'Email or password is invalid'
    end
  end
end
