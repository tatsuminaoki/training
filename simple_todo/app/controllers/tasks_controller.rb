class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    #@tasks = Task.all.order(created_at: :desc)
    @tasks = Task.search(params[:search]).order(created_at: :desc)
  end



  def show
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t('flash.task.created')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.task.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.task.destroyed')
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :user_id, :limit, :priority, :status)
    end
end
