# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @search_title = params[:search_title]
    @search_status = params[:search_status]
    @search_sort = params[:search_sort]
    @tasks = Task.search(title: @search_title, status: @search_status, sort: @search_sort)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t('success.create', it: Task.model_name.human)
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('success.update', it: Task.model_name.human)
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.delete

    flash[:success] = I18n.t('success.delete', it: Task.model_name.human)
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :status, :priority)
  end
end
