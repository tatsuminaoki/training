# frozen_string_literal: true

module LoginHelper
  def sign_in_with(user)
    visit sign_in_path
    fill_in 'session[name]', with: user.name
    fill_in 'session[password]', with: 'password'
    click_on I18n.t('sessions.new.sign_in')
  end
end
