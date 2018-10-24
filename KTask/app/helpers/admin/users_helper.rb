module Admin::UsersHelper
  def users_taskamount(user)
    user.tasks.count
  end
end
