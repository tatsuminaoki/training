module Admin::UsersHelper
  def tasks_count_message(user_id:, tasks:)
    return raw %(#{link_to tasks.size, admin_user_path(id: user_id)}) if tasks.size > 0
    tasks.size
  end

  def user_role_message(role:)
    role_str = I18n.t role, scope: "enum.user.role"
    raw %(<span class="label label-#{role}">#{role_str}</span>)
  end
end
