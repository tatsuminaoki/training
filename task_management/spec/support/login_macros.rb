module LoginMacros
  def login(mail_address, password)
    visit login_path
    fill_in 'mail_address', with: mail_address if mail_address.present?
    fill_in 'password', with: password if password.present?
    click_button I18n.t('helpers.submit.login')
  end

  def logout
    click_on 'log out'
  end
end
