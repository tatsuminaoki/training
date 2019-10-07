class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:user).search(params).page(params[:page])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new()
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t("message.task.complete_create")
    else
      render "new"
    end

  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to @task, notice: t("message.task.complete_update")
    else
      render "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to root_path, notice: t("message.task.complete_delete")
  end

  private

  def task_params
    params.require(:task).permit(:user_id, :name, :description, :status, :priority, :duedate)
  end
end
