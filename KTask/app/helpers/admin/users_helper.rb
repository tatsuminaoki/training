module Admin::UsersHelper
  def users_tasks_amount(user)
    user.tasks.count
  end
end
