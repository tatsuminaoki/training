module UsersHelper
  def users_taskamount(user)
    user.tasks.count
  end
end
