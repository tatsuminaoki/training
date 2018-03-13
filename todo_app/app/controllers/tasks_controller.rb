class TasksController < ApplicationController

  def index
    @input_title = params[:title]
    @selected_status = params[:status]
    @selected_sort = params[:sort]

    @tasks = Task.search(params)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = I18n.t('success.create', it: Task.model_name.human)
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = I18n.t('success.update', it: Task.model_name.human)
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.delete

    flash[:success] = I18n.t('success.delete', it: Task.model_name.human)
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :status, :priority)
  end
end
