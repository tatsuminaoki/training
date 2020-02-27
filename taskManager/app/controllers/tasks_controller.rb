class TasksController < ApplicationController
  before_action :task, only: [:destroy, :show, :edit, :update]
  def index
    @tasks = Task.order(id: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('flash.create.success')
      redirect_to @task
    else
      flash.now[:danger] = t('flash.create.danger')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t('flash.update.success')
      redirect_to @task
    else
      flash.now[:danger] = t('flash.update.danger')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('flash.remove.success')
    else
      flash[:danger] = t('flash.remove.danger')
    end
    redirect_to tasks_url
  end

  def task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :summary,
      :description,
      :priority,
      :status,
      :due
    )
  end
end
