module  Admin::UsersHelper
  def tasks_amount(user)
    user.tasks.count
  end

  def loged_in?
    current_user.present?
  end
end
