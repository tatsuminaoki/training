# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    search_name = params[:search_name]
    search_status = params[:search_status]
    @tasks = Task.all
    @tasks = @tasks.where(['name LIKE ?', "%#{search_name}%"]) if search_name.present?
    @tasks = @tasks.where(status: search_status) if search_status.present?
    @tasks = if params.key?(:sort)
               @tasks.order(deadline: params[:sort].to_sym, created_at: :desc)
             else
               @tasks.order(created_at: :desc)
             end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path, notice: t('flash.task.create_success')
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
      redirect_to root_path, notice: t('flash.task.update_success')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_path, notice: t('flash.task.destroy_success')
  end

  private

  def task_params
    params.require(:task).permit(:name, :content, :deadline, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
