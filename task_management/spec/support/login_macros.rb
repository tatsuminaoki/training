module LoginMacros
  def login(user_name, password)
    visit login_path
    fill_in 'user_name', with: user_name if user_name.present?
    fill_in 'password', with: password if password.present?
    click_button I18n.t('helpers.submit.login')
  end

  def logout
    click_on 'log out'
  end
end
