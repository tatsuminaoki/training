module LoginSupport
  def login_as(user)
    visit root_path
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    find("input[type=submit]").click
  end
end
