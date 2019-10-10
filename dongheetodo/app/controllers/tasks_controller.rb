class TasksController < ApplicationController
  before_action :authenticate
  before_action :has_own_task, only: %i(show edit update destroy)

  def index
    @tasks = params[:label].present? ?
             Task.preload(:labels).left_joins(:labels).own(current_user).search(params).page(params[:page]) :
             Task.includes(:labels).own(current_user).search(params).page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:success] = t("message.success.complete_create")
      redirect_to @task
    else
      render "new"
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = t("message.success.complete_update")
      redirect_to @task
    else
      render "edit"
    end
  end

  def destroy
    @task.destroy
    flash[:success] = t("message.success.complete_delete")
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :name, :description, :status, :priority, :duedate, label_ids: [])
  end

  def authenticate
    unless current_user
      redirect_to login_url
    end
  end

  def has_own_task
    @task = Task.find(params[:id])
    unless @task.user_id == current_user.id
      render_401
    end
  end
end
