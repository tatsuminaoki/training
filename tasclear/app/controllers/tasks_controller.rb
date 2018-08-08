# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if logged_in?
      @tasks = current_user.tasks.add_search_and_order_condition(params).page(params[:page])
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
      @task.save_labels(params[:task][:label_name])
    end
    redirect_to root_path, notice: t('flash.task.create_success')
  rescue ActiveRecord::RecordInvalid
    @label_list = params[:task][:label_name]
    render :new
  rescue StandardError => e
    logger.error e
    raise
  end

  def show
  end

  def edit
    @label_list = @task.labels.pluck(:name).join(',')
  end

  def update
    Task.transaction do
      @task.update!(task_params)
      @task.save_labels(params[:task][:label_name])
    end
    redirect_to root_path, notice: t('flash.task.update_success')
  rescue ActiveRecord::RecordInvalid
    @label_list = params[:task][:label_name]
    render :edit
  rescue StandardError => e
    logger.error e
    raise
  end

  def destroy
    @task.save_labels(nil)
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
