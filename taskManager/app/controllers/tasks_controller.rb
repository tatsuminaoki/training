class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @tasks = Task.new
  end

  def create
    @tasks = Task.create(task_params)
    redirect_to @task, notice: 'タスクを登録しました'
  end

  def show
  end

  def edit
  end

  def update
    @tasks.update(tasks_params)
    redirect_to @task, notice: 'タスクを更新しました'
  end

  def destroy
    @tasks.destroy
    redirect_to tasks_url notice: 'タスクを削除しました'
  end

  def task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :status, :due)
  end

end
