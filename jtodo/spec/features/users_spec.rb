require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let!(:user) { create(:user) }

  scenario 'ログインに失敗した後、正常にログインする' do
    visit login_path
    submit_form

    expect(page).to have_css('div.alert')

    fill_in 'session_name', with: 'user_test2'
    fill_in 'session_password', with: 'userpass'

    submit_form
    
    expect(page).to have_css('div.alert')

    fill_in 'session_name', with: 'user_test1'
    fill_in 'session_password', with: 'userpass'

    submit_form
  end

  scenario '正常に会員登録する' do
    visit signup_path
    
    fill_in 'user_name', with: 'test1'
    fill_in 'user_password', with: 'testpass'
    fill_in 'user_password_confirmation', with: 'testpass'

    submit_form

    fill_in 'session_name', with: 'test1'
    fill_in 'session_password', with: 'testpass'

    submit_form

    expect(page.find('header')).to have_content 'Hello, test1!'
  end

end
