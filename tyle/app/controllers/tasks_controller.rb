class TasksController < ApplicationController
  before_action :task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    # temporary
    @task.user = User.find_by(id: 1)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created!'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    # temporary
    @task.user = User.find_by(id: 1)

    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_url, notice: 'Task was successfully destroyed!'
    else
      render :index
    end
  end

  private

  def task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :priority, :status, :due)
  end
end
