class TasksController < ApplicationController
  protect_from_forgery except: :new
  def index
    @tasks = if params[:statuses].present?
              Task.where('task_name like ?', "%#{params[:search]}%").where(status: params[:statuses][:status])
            else
              Task.where('task_name like ?', "%#{params[:search]}%")
            end
    @tasks = case params[:sort]
    when 'due_date_asc'
      @tasks.all.order('due_date ASC')
    when 'due_date_desc'
      @tasks.all.order('due_date DESC')
    else
      @tasks.all.order('created_at DESC')
    end
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
      flash.now[:alert] = I18n.t('flash.failure_create')
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: I18n.t('flash.success_update')
    else
      flash.now[:alert] = I18n.t('flash.failure_update')
      render :edit
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
    params.require(:task).permit(:task_name, :description, :due_date, :status)
  end
end
