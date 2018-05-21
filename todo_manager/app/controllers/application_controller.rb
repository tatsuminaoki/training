class ApplicationController < ActionController::Base
  include ApplicationHelper

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
