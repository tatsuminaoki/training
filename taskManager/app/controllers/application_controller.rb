class ApplicationController < ActionController::Base
  before_action :store_location
  before_action :check_session
  rescue_from ActionController::RoutingError, with: :error_404
  rescue_from Exception, with: :error_500
  helper_method :sort_column, :sort_direction

  include CommonLogin
  include LoginHelper

  def error_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def error_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  private

  def check_session
    return redirect_to(:controller => '/login',:action => 'index') unless logged_in?
    return redirect_to(:controller => 'login',:action => 'index') unless valid_session?
    User.current = User.find_by(id: session['user_id'])
  end

  def store_location
    session[:return_to] = request.url
  end

  def make_simple_message(column: 'task', action:, result: true)
    result_str = result ? 'words.success' : 'words.failure'
    I18n.t('messages.simple_result',
      name: I18n.t("words.#{column}"),
      action: I18n.t("actions.#{action}"),
      result: I18n.t(result_str))
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : ''
  end
end
