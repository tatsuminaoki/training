# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_url, notice: t('flash.task.create', :task => @task.title)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: t('flash.task.update', :task => @task.title)
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: t('flash.task.delete', :task => @task.title)
    else
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
