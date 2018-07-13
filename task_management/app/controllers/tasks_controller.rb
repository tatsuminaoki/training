class TasksController < ApplicationController
  protect_from_forgery except: :new
  before_action :authorize_user

  def index
    @tasks = Task.search(params, @current_user).page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
    log_out_invalid_user
  end
  
  def edit
    @task = Task.find(params[:id])
    log_out_invalid_user
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
    @task.user_id = @current_user.id
    if @task.save
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_create')
    else
      flash.now[:alert] = I18n.t('flash.failure_create')
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: I18n.t('flash.success_update')
    else
      flash.now[:alert] = I18n.t('flash.failure_update')
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_delete', :task => @task.task_name)
    else
      redirect_to ({action: 'show'}), id: params[:id], alert: I18n.t('flash.failure_delete', :task =>@task.task_name)
    end
  end

  def tasks_params
    params.require(:task).permit(:task_name, :description, :due_date, :status, :priority)
  end

  def authorize_user
    redirect_to login_path, alert: I18n.t('flash.require_log_in') if get_current_user.nil?
  end
end
