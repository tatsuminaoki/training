# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :find_user, only: %i[index new create]
  before_action :find_labels, except: :show

  def index
    @tasks = @user.tasks.includes(:labels).find_with_params(params)
  end

  def new
    @task = @user.tasks.new
  end

  def create
    @task = @user.tasks.new(task_params)
    if @task.save
      flash[:message] = t :new_task_created
      redirect_to @task
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:message] = t :task_updated
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:message] = t :task_deleted
      redirect_to tasks_path
    else
      redirect_to @task
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :status, :deadline, label_ids: [])
  end

  def find_task
    @task = current_user.tasks.includes(:labels).find(params[:id])
  end

  def find_user
    @user = current_user
  end

  def find_labels
    @labels = Label.all
  end
end
