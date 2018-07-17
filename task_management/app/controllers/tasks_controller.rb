class TasksController < ApplicationController
  protect_from_forgery except: :new
  protect_from_forgery except: :update # PATCHリクエストで"Can't verify CSRF token authenticity."と表示されるため追加
  before_action :log_out_invalid_user, only: [:show, :edit]

  def index
    @tasks = Task.search(params, current_user).page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
  end
  
  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
    @task.user_id = current_user.id
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

  private

  def tasks_params
    params.require(:task).permit(:task_name, :description, :due_date, :status, :priority)
  end

  def log_out_invalid_user
    user_id = Task.find(params[:id]).user_id
    if user_id != current_user.id
      redirect_to root_path, alert: I18n.t('flash.access_invalid_task')
    end
  end
end
