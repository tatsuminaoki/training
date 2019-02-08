module SessionMacros
  def login
    visit login_path

    fill_in :session_email, with: 'aaaa@gmail.com'
    fill_in :session_password, with: 'abc'

    click_button 'ログインする'
  end

  def logout
    click_button 'ログアウトする'
  end
end
