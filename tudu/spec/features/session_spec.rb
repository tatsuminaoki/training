require 'rails_helper'

RSpec.feature 'session management', :type => :feature do

  describe 'create session and destroy session' do
    context 'create a new session and destroy session' do
      scenario 'End User log in' do
        create(:user)
        visit login_path

        expect(page).not_to have_text('ログアウト')
        fill_in 'session[email]', with: 'hogehoge@example.com'
        fill_in 'session[password]', with: 'hogehoge'
        click_button 'ログイン'

        expect(page).to have_text('ログアウト')

        click_link 'ログアウト'
        expect(page).not_to have_text('ホーム')
      end
    end
  end
end
