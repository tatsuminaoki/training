module Admin::UsersHelper
  def convert_date_format(date)
    date.strftime("%Y年%m月%d日 %H時%M分")
  end

  def new_page?
    request.path_info == new_admin_user_path
  end
end
