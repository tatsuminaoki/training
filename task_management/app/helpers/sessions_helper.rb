module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def get_current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def log_out_invalid_user
    if @task.user_id != @current_user.id
      redirect_to root_path, alert: I18n.t('flash.access_invalid_task')
    end
  end
end
