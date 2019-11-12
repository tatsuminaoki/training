require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:rack_test)
    @user = create(:user)
    @user_session = create(:user_session, user_id: @user.id)
  end

  context 'When the login information is correct' do
    it 'Success to login' do
      visit login_path

      fill_in 'session[email]', with: 'hoge@example.com'
      fill_in 'session[password]', with: 'hoge123'
      click_on 'commit'

      expect(page).to have_content I18n.t('message.lead', name: @user.name)
    end
  end

  context 'When the email is not registered' do
    it 'Validation error shows up' do
      visit login_path

      fill_in 'session[email]', with: 'fuga@example.com'
      fill_in 'session[password]', with: 'hoge123'
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.login.fail')
    end
  end

  context 'When the password is wrong' do
    it 'Validation error shows up' do
      visit login_path

      fill_in 'session[email]', with: 'hoge@example.com'
      fill_in 'session[password]', with: 'hoge1234'
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.login.fail')
    end
  end

  context 'When the email is empty' do
    it 'Validation error shows up' do
      visit login_path

      fill_in 'session[email]', with: ''
      fill_in 'session[password]', with: 'hoge123'
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.login.fail')
    end
  end

  context 'When the password is empty' do
    it 'Validation error shows up' do
      visit login_path

      fill_in 'session[email]', with: 'hoge@example.com'
      fill_in 'session[password]', with: ''
      click_on 'commit'

      expect(page).to have_content I18n.t('flash.login.fail')
    end
  end
end
