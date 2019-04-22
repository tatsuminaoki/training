require 'rails_helper'

RSpec.feature 'session management', :type => :feature do

  describe 'create session and destroy session' do
    context 'create a new session and destroy session' do
      scenario 'End User log in' do
        @user = create(:user)
        visit login_path

        expect(page).not_to have_text('ホーム')
        fill_in 'session[email]', with: @user.email
        fill_in 'session[password]', with: 'hogehoge'
        click_button 'ログイン'

        expect(page).to have_text('ホーム')

        click_link 'ログアウト'
        expect(page).not_to have_text('ホーム')
      end
    end
  end
end
