class TasksController < ApplicationController
  before_action :task, only: [:destroy, :show, :edit, :update]
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url notice: 'Task was successfully destroyed.'
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
