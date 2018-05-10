class AdminFilter
  def before(controller)
    user = controller.session[:user]
    # 管理者URLを隠すため404とする
    raise ApplicationController::NotFound unless is_admin?(user)
  end

  def is_admin?(user)
    ActiveRecord::Type::Boolean.new.cast(user['admin_flag'])
  end
end
