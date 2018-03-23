module Admin
  module UsersHelper
    def user_form_path
      case request.path_info
      when new_admin_user_path then
        admin_users_path
      when edit_admin_user_path then
        admin_user_path
      end
    end
  end
end
