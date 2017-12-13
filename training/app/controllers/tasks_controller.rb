class TasksController < ApplicationController
  before_action :convert_params_to_enum

  def index

    case params[:end_date]
      when 'asc'
        @tasks = Task.order(end_date: :asc)
      when 'desc' 
        @tasks = Task.order(end_date: :desc)
      else
        @tasks = Task.order({created_at: :desc})
    end
    if params[:status].present?
      @tasks = Task.where('status = ?', params[:status])
    end
    if params[:name].present?
      @tasks = Task.where('name = ?', params[:name])
    end
    #todo and検索実装する
    #todo 検索した単語の持ち回し機能
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

  def convert_params_to_enum
    return false if params[:task].nil?
    params[:task][:status] = Integer(params[:task][:status]) if params[:task][:status].present?
  rescue ArgumentError
    return false
  end
end
