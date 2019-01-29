# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @search = if params[:q]
                current_user.tasks.ransack(params[:q])
              else
                current_user.tasks.ransack(recent: true)
              end
    @search_tasks = @search.result
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
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task,
                  notice: I18n.t('notification.create', task_title: @task.title)
    else
      render :new
    end
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url,
                notice: I18n.t('notification.update', task_title: @task.title)
  end

  def destroy
    @task.destroy
    redirect_to tasks_url,
                notice: I18n.t('notification.destroy', task_title: @task.title)
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :end_at)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
