class AdminFilter
  def before(controller)
    user = controller.session[:user]
    # 管理者URLを隠すため404とする
    raise ApplicationController::NotFound if !ActiveRecord::Type::Boolean.new.cast(user['admin_flag'])
  end
end
