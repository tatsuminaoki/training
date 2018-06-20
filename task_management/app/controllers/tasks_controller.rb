class TasksController < ApplicationController
  protect_from_forgery except: :new
  def index
    @tasks = Task.all.order('created_at DESC')
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
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_create')
    else
      if @task.errors.details[:task_name][0][:error] == :blank
        redirect_to ({action: 'new'}), alert: I18n.t('activerecord.format', attribute: I18n.t('activerecord.attributes.task.task_name'), message: I18n.t('activerecord.message.blank'))
      else
        redirect_to ({action: 'new'}), alert: I18n.t('activerecord.format', attribute: I18n.t('activerecord.attributes.task.task_name'), message: I18n.t('activerecord.message.too_long', count: @task.errors.details[:task_name][0][:count]))
      end
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: I18n.t('flash.success_update')
    else
      p '================='
      p @task.errors.full_messages
      if @task.errors.details[:task_name][0][:error] == :blank
        redirect_to ({action: 'edit'}), alert: I18n.t('activerecord.format', attribute: I18n.t('activerecord.attributes.task.task_name'), message: I18n.t('activerecord.message.blank'))
      else
        redirect_to ({action: 'edit'}), alert: I18n.t('activerecord.format', attribute: I18n.t('activerecord.attributes.task.task_name'), message: I18n.t('activerecord.message.too_long', count: @task.errors.details[:task_name][0][:count]))
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_delete', :task => @task.task_name)
    else
      redirect_to ({action: 'show'}), id: params[:id], alert: I18n.t('flash.failure_delete', :task =>@task.task_name)
    end
  end

  def tasks_params
    params.require(:task).permit(:task_name,:description)
  end
end
