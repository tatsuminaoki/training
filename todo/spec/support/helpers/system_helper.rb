# frozen_string_literal: true

module SystemHelper
  def log_in_as(user)
    visit login_path
    fill_in 'session_name', with: user.name
    fill_in 'session_password', with: user.password
    click_on 'ログイン'
  end
end
