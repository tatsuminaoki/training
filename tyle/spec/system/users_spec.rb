# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'register and login' do
    it 'register and login' do
    # register
    visit new_user_path
    fill_in 'user_name', with: 'user1'
    fill_in 'user_login_id', with: 'id1'
    fill_in 'user_password', with: 'password1'
    fill_in 'user_password_confirmation', with: 'password1'
    click_on '登録する'

    # login
    fill_in 'session_login_id', with: 'id1'
    fill_in 'session_password', with: 'password1'
    click_on 'ログイン'
    sleep 1

    expect(page).to have_content 'TYLE'
    end
  end
end
