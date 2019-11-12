module LoginMacros
  def login(user)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    # fill_in 'session[email]', with: 'hoge@example.com'
    # fill_in 'session[password]', with: 'hoge123'
    click_on 'commit'
  end
end
