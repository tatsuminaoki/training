class TasksController < ApplicationController
  protect_from_forgery except: :new
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end
  
  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
    if @task.save
      redirect_to ({action: 'index'}), notice: t('flash.success_create')
    else
      redirect_to ({action: 'new'}), alert: t('flash.failure_create')
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: t('flash.success_update')
    else
      redirect_to ({action: 'edit'}), alert: t('flash.failure_update')
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to ({action: 'index'}), notice: t('flash.success_delete', :task => @task.task_name)
    else
      redirect_to ({action: 'show'}), id: params[:id], alert: t('flash.failure_delete', :task =>@task.task_name)
    end
  end

  def tasks_params
    params.require(:task).permit(:task_name,:description)
  end
end
