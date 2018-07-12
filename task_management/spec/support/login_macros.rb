module LoginMacros
  def login(user)
    visit login_path
    fill_in 'user_name', with: user.user_name
    fill_in 'password', with: user.password
    click_button I18n.t('helpers.submit.login')
  end

  def logout
    click_on 'log out'
  end
end
