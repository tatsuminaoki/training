# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :task, only: %i[show edit update destroy]

  def index
    @tasks = Task.user_id(@current_user.id).name_like(params[:name]).priority(params[:priority]).status(params[:status]).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: t('message.task.created')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('message.task.updated')
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: t('message.task.destroyed')
    else
      render :index
    end
  end

  private

  def task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :status, :due)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
