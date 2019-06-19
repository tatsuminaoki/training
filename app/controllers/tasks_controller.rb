class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all.includes(:user).search(params)
    @params = params
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

    if @task.save
      redirect_to @task, success: 'タスクを作成しました'
    else
      render :new, warning: 'タスクの作成に失敗しました'
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, info: 'タスクを編集しました'
    else
      render :edit, warning: 'タスクの編集に失敗しました'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, danger: 'タスクを削除しました'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.fetch(:task, {}).permit(:title, :detail, :status, :user_id)
  end
end
