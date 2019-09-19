# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def index
    search_params = params.permit(q: [:name, { statuses: [] }])
    @search_query = search_params[:q] || {}

    @tasks = Task.includes(:user)
    @tasks = @tasks.where(status: @search_query[:statuses]) if @search_query[:statuses].present?
    @tasks = @tasks.name_like(@search_query[:name]) if @search_query[:name].present?
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
      redirect_to task_path(@task.id), flash: { error: "タスクの削除に削除しました。 id=#{@task.id}" }
    end
  end

  private

  def find_resource
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :detail, :status)
  end
end
