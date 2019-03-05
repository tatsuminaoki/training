class TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :show, :edit, :update]
  def new
    @task = Task.new
  end

  def create
    Task.create(task_params)
    redirect_to tasks_path, notice: 'タスクを作成しました！'
  end

  def index
    @tasks = Task.all
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクを編集しました！'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path(@task.id), notice: 'タスクを削除しました！'
  end

  private

  def task_params
    params.require(:task).permit(:name, :content, :priority, :status, :endtime)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
