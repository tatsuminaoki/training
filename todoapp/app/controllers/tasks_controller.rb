# frozen_string_literal: true

class TasksController < ApplicationController
  PER = 8

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_label, only: [:index, :show, :edit, :new, :create]

  def index
    @search = if params[:q]
                current_user.tasks.includes(:labels).ransack(params[:q])
              else
                current_user.tasks.includes(:labels).ransack(recent: true)
              end
    @search_tasks = @search.result.page(params[:page]).per(PER)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task,
                  notice: I18n.t('notification.create', value: @task.title)
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url,
                  notice: I18n.t('notification.update', value: @task.title)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url,
                notice: I18n.t('notification.destroy', value: @task.title)
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :end_at, { label_ids: [] })
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def set_label
    @labels = current_user.labels
  end
end
