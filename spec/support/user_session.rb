module UserSession
  module ControllerSpecHelper
    def user_login(user: create(:user))
      request.session[:current_user_id] = user.id
    end
  end

  module SystemSpecHelper
    def user_login(user: create(:user))
      user.create_user_credential(password: "password")
      visit new_session_path

      fill_in "session[email]", with: user.email
      fill_in "session[password]", with: "password"
      click_on "ログイン"
    end
  end
end
