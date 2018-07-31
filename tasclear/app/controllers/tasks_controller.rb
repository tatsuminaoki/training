# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if logged_in?
      @tasks = Task.add_search_and_order_condition(current_user.tasks, params).page(params[:page])
    else
      redirect_to new_session_path
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
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
    params.require(:task).permit(:name, :content, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
