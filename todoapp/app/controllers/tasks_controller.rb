# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    param = task_params.merge(status: Task::STATUS_NEW_TASK)
    @task = current_user.tasks.new(param)

    if @task.save
      redirect_to @task, notice: "タスク「#{@task.title}」を登録しました。"
    else
      render :new
    end
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.title}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.title}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :end_at)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
