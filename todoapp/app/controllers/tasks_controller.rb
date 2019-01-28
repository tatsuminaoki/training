# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = if sort_params.to_hash.length.zero?
               current_user.tasks.recent
             else
               current_user.tasks.order(sort_column + ' ' + sort_direction)
             end
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
    params.require(:task).permit(:title, :description, :end_at)
  end

  def sort_params
    params.permit(:direction, :sort)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : :id.to_s
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
