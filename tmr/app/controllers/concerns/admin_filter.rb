class AdminFilter
  def before(controller)
    user = controller.session[:user]
    raise ApplicationController::Forbidden if !ActiveRecord::Type::Boolean.new.cast(user['admin_flag'])
  end
end
