# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:destroy, :show, :edit, :update]
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: I18n.t('activerecord.flash.task_create')
    else
      flash[:alert] =  "#{@task.errors.count}件のエラーがあります"
      render 'new'
    end
  end

  def index
    @tasks = Task.all.order(created_at: :desc)
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
      flash[:alert] =  "#{@task.errors.count}件のエラーがあります"
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
end
