module  Admin::UsersHelper
  def tasks_amount(user)
    user.tasks.count
  end

  def logged_in?
    current_user.present?
  end
end
