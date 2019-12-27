class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.filter_by_ids_or_all(params[:filtered_ids])
                 .search_result(params[:title_keyword], params[:current_status])
                 .order_by_due_date_or_default(params[:due_date_direction])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: t('flash_message.create_complete')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash_message.update_complete')
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: t('flash_message.delete_success')
    else
      redirect_to tasks_url, notice: t('flash_message.delete_fail')
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end
end
