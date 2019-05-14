# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'UsersLogin', type: :feature do
  before do
    @user = FactoryBot.create(:user)
  end

  scenario 'change nav contents after log in ' do
    visit login_path
    expect(page).to have_css('a', text: 'Log in')

    fill_in 'session_name', with: @user.name
    fill_in 'session_password', with: @user.password
    click_button 'Log in'

    expect(page).to_not have_css('a', text: 'Log in')
    expect(page).to have_css('a', text: 'Log out')
    expect(page).to have_css('a', text: 'Profile')
  end
end
