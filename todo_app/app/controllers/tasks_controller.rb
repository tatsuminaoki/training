# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_available_labels, only: %i[new edit]
  before_action :require_login

  def index
    @search_title = params[:search_title]
    @search_status = params[:search_status]
    @search_sort = params[:search_sort]
    @page = params[:page]
    @tasks = Task.search(user_id: current_user.id, title: @search_title, status: @search_status, sort: @search_sort, page: @page)
  end

  def new
    @task = Task.new
  end

  def create 
    @task = Task.new(task_params)
    @task.user_id = current_user.id

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
    params.require(:task).permit(:title, :description, :deadline, :status, :priority, :label_list)
  end

  def set_available_labels
    @available_labels = ActsAsTaggableOn::Tag.all.pluck(:name).to_json.html_safe
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end
