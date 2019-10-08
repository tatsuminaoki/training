class TasksController < ApplicationController
  before_action :authenticate
  def index
    @tasks = Task.includes(:user).own(current_user).search(params).page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
    checkOwner(@task)
  end

  def new
    @task = Task.new()
  end

  def edit
    @task = Task.find(params[:id])
    checkOwner(@task)
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to @task, notice: t("message.task.complete_create")
    else
      render "new"
    end

  end

  def update
    @task = Task.find(params[:id])
    checkOwner(@task)

    if @task.update(task_params)
      redirect_to @task, notice: t("message.task.complete_update")
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    checkOwner(@task)
    @task.destroy

    redirect_to root_path, notice: t("message.task.complete_delete")
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :name, :description, :status, :priority, :duedate)
  end

  def authenticate
    unless current_user
      redirect_to login_url
    end
  end

  def checkOwner(task)
    p task.user_id
    unless task.user_id == current_user.id
      render_401
    end
  end
end
