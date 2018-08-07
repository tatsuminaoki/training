# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if logged_in?
      @tasks = Task.add_search_and_order_condition(current_user.tasks, params).page(params[:page])
      @search_attr = params
    else
      redirect_to new_session_path
    end
  end

  def new
    @task = Task.new
  end

  def create
    Task.transaction do
      @task = Task.new(task_params)
      @task.user_id = current_user.id
      @task.save!
      label_list = params[:task][:label_name].split(',')
      @task.save_labels(label_list)
    end
    redirect_to root_path, notice: t('flash.task.create_success')
  rescue StandardError
    @label_list = params[:task][:label_name]
    render :new
  end

  def show
  end

  def edit
    @label_list = @task.labels.pluck(:name).join(',')
  end

  def update
    Task.transaction do
      @task.update!(task_params)
      label_list = params[:task][:label_name].split(',')
      @task.save_labels(label_list)
    end
    redirect_to root_path, notice: t('flash.task.update_success')
  rescue StandardError
    render :edit
  end

  def destroy
    @task.save_labels([])
    @task.destroy
    redirect_to root_path, notice: t('flash.task.destroy_success')
  end

  private

  def task_params
    params.require(:task).permit(:name, :content, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
