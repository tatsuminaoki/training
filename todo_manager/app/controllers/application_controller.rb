class ApplicationController < ActionController::Base
  include ApplicationHelper

  unless Rails.env.development?
    rescue_from Exception, with: :_render_500
    rescue_from ActiveRecord::RecordNotFound, with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def _render_404
    render template: 'errors/404', status: 404, layout: false, content_type: 'text/html'
  end

  def _render_500
    render template: 'errors/500', status: 500, layout: false, content_type: 'text/html'
  end

  NO_OF_LABELS = 3

  def save_users(flash_name, redirect_path, render_path)
    if @user.save
      session[:user_id] = @user.id if flash_name == 'signup'
      flash[:notice] = I18n.t("flash.users.#{flash_name}")
      redirect_to(redirect_path)
    else
      render render_path
    end
  end

  def save_todos(flash_name, redirect_path, render_path)
    if @todo.save
      flash[:notice] = I18n.t("flash.todos.#{flash_name}")
      redirect_to(redirect_path)
    else
      (NO_OF_LABELS - @todo.labels.size).times { @todo.labels.build }
      render render_path
    end
  end

  def set_todos
    @todo = Todo.new
    NO_OF_LABELS.times { @todo.labels.build }
    @todo.deadline = Time.current.tomorrow.strftime('%Y-%m-%dT%H:%M')
  end

  def authenticate_user
    if current_user.nil?
      flash[:notice] = I18n.t('flash.users.login.must')
      redirect_to(login_path)
    end
  end

  def forbid_login_user
    if current_user
      flash[:notice] = I18n.t('flash.users.login.already')
      redirect_to(root_path)
    end
  end
end
