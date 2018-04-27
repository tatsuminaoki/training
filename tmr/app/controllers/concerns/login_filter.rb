class LoginFilter
  def before(controller)
    user = controller.session[:user]

    if !user.present?
      controller.redirect_to controller.login_path
    end
  end
end
