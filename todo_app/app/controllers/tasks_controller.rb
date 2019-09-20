# frozen_string_literal: true

class TasksController < ApplicationController
  before_action -> { redirect_to new_session_path }, unless: :logged_in?
  before_action :find_resource, only: %i[show edit update destroy]

  def index
    search_params = params.permit(q: [:name, { statuses: [] }])
    @search_query = search_params[:q] || {}

    @tasks = scoped_collection
    @tasks = @tasks.where(status: @search_query[:statuses]) if @search_query[:statuses].present?
    @tasks = @tasks.name_like(@search_query[:name]) if @search_query[:name].present?
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to task_path(@task.id), flash: { success: 'タスクを作成しました。' }
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task.id), flash: { success: 'タスクを更新しました。' }
    else
      render :new
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, flash: { success: "タスクを削除しました。 id=#{@task.id}" }
    else
      redirect_to task_path(@task.id), flash: { error: "タスクの削除に失敗しました。 id=#{@task.id}" }
    end
  end

  private

  def scoped_collection
    Task.where(user_id: current_user.id).includes(:user)
  end

  def find_resource
    @task = scoped_collection.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :detail, :status)
  end
end
