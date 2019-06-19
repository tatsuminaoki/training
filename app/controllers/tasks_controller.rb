class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :prevent_unauthorized_changes, only: [:show, :create]

  def index
    tasks = Task.all.search(params)
    @tasks = tasks.includes(:user).select { |task| task.user_id == current_user.id }
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
    @task.user_id = current_user.id

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

  def prevent_unauthorized_changes
    redirect_to root_path, warning: '別のユーザーのタスクです' unless @task.user_id == current_user.id
  end
end
