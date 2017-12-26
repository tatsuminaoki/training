module Admin::UsersHelper
  def convert_date_format(date)
    date.strftime("%Y/%m/%d %H:%M")
  end

  def new_page?
    request.path_info.in?([new_admin_user_path, admin_users_path])
  end
end
