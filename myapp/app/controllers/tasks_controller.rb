class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  before_action :sanitize_task_params, only: [:create, :update]

  def index
    @tasks = Task.all
    @tasks = @tasks.where("name like ?", "%#{params[:name]}%") if params[:name].present?
    @tasks = @tasks.where("status = ?", params[:status].to_i) if params[:status].present?
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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
    params.require(:task).permit(:name, :description, :status)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def sanitize_task_params
    params[:task][:status] = params[:task][:status].to_i
  end
end
