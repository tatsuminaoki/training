# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :show, :edit, :update]
  before_action :loggin_check, only: [:new, :edit, :show, :destroy, :index]
  before_action :user_check, only: [:edit, :destroy]
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to tasks_path, notice: I18n.t('activerecord.flash.task_create')
    else
      flash[:alert] = "#{@task.errors.count}件のエラーがあります"
      render 'new'
    end
  end

  def index
    @tasks = current_user.tasks.sort_and_search(params).page(params[:page]).per(10)
    @search_attr = params
  end

  def show
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t('activerecord.flash.task_edit')
    else
      flash[:alert] = "#{@task.errors.count}件のエラーがあります"
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path(@task.id), notice: I18n.t('activerecord.flash.task_delete')
  end

  private

  def task_params
    params.require(:task).permit(:name, :content, :priority, :status, :endtime)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def loggin_check
    if session[:user_id] == nil
      redirect_to new_session_path, notice:"ログインしてください"
    end
  end

  def user_check
    @task = Task.find(params[:id])
    unless current_user.id == @task.user_id
      redirect_to tasks_path, notice:"投稿者以外は編集,削除はできません"
    end
  end
end
