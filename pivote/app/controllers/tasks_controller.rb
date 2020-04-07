# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :my_labels, only: %i[index new create edit update]

  def index
    @search_form = TaskSearchForm.new(search_params)
    @tasks = @search_form.search(current_user.tasks.includes(:labels)).page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
    3.times { @task.task_labels.build }
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))
    if @task.save
      redirect_to tasks_url, notice: t('flash.create', target: @task.title)
    else
      build_task_labels
      render :new
    end
  end

  def edit
    build_task_labels
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: t('flash.update', target: @task.title)
    else
      build_task_labels
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: t('flash.delete', target: @task.title)
    else
      render :index
    end
  end

  private

  def search_params
    params.require(:search).permit(:title, :priority, :status, :sort_column, :direction, :label) unless params[:search].nil?
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status, :deadline, task_labels_attributes: %i[id task_id label_id _destroy])
  end

  def find_task
    @task = current_user.tasks.includes(:labels).find(params[:id])
  end

  def my_labels
    @labels = current_user.labels.order_by_id_desc
  end

  def build_task_labels
    @task.task_labels.build until @task.task_labels.size >= 3
  end
end
