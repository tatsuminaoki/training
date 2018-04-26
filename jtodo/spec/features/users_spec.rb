require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let!(:user) { create(:user) }

  scenario '会員登録する' do
    visit signup_path
    
    fill_in 'user_name', with: 'test1'
    fill_in 'user_password', with: 'testpass'
    fill_in 'user_password_confirmation', with: 'testpass'

    submit_form

    fill_in 'session_name', with: 'test1'
    fill_in 'session_password', with: 'testpass'

    submit_form

    expect(page).to have_content 'test1'
  end
end
