class TasksController < ApplicationController
  before_action :convert_params_to_int

  def index
    @name = params[:name]
    @status = params[:status]
    @order = params[:order]

    @tasks = Task.search(params)
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: I18n.t('tasks.controller.messages.created')
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      redirect_to @task, notice: I18n.t('tasks.controller.messages.updated')
    else
      render :edit
    end
  end

  def destroy
    Task.find(params[:id]).destroy!
    redirect_to tasks_path, notice: I18n.t('tasks.controller.messages.deleted')
  end

  private

  def task_params
    params.require(:task).permit(
      :user_id,
      :name,
      :description,
      :priority,
      :status,
      :label_id,
      :end_date,
    )
  end

  def convert_params_to_int
    return false if params[:task].nil?
    params[:task][:status] = Integer(params[:task][:status]) if params[:task][:status].present?
  rescue ArgumentError
    return false
  end
end
