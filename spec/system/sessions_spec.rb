# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:user) { create(:user) }
  let!(:user_credential) { user.create_user_credential(password: 'password') }

  specify 'An user login' do
    visit new_session_path

    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: 'password'
    click_on 'ログイン'

    expect(page).to have_content('タスク管理')
  end
end
