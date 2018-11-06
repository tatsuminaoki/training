module Admin::UsersHelper
  def task_count_message(user_id:, task:)
    return raw %(#{link_to task.size, admin_user_path(id: user_id)}) if task.size > 0
    task.size
  end
end
