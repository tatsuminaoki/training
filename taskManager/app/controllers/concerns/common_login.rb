# == CommonLogin:
# Common Login process module
#
module CommonLogin
  extend ActiveSupport::Concern

  private

  def create_session_key
    SecureRandom.base64(160)
  end

  def make_session(user:, session_key: nil)
    session_key = create_session_key if session_key.nil?
    logger.debug("[set_session]set session_key=#{session_key}")
    session[:session_key] = session_key
    session[:user_id] = user.id
    json = make_json_values(user: user)
    Redis.current.set(session_key, json)
  end

  def make_json_values(user:)
    hash = {}
    hash[:user_id] = user[:id] if user[:id].present?
    hash.to_json
  end

  def delete_session(session_key: session[:session_key])
    Redis.current.del(session_key)
  end

  def valid_session?
    result_redis = Redis.current.get(session[:session_key])
    logger.debug("[check_session_data]get_session_key session_key=#{session[:session_key]} result=#{result_redis.inspect}")
    return false unless result_redis.present?
    session_user = JSON.parse(result_redis)
    return false unless session_user['user_id'] == session[:user_id]
    return true
  end

  def current_user
    current_user ||= User.find_by(id: session['user_id'])
  end

  def progress_logout
    delete_session unless current_user.nil?
    session.delete(:session_key)
    flash[:info] = I18n.t("messages.logout")
    redirect_to(:controller => 'login',:action => 'index')
  end
end