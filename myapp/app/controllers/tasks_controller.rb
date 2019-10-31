class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:message] = 'A new task created!'
      redirect_to @task
    else
      render 'new'
    end
  end

  def show

  end

  def edit

  end

  def update
    if @task.update(task_params)
      flash[:message] = 'Task updated!'
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:message] = 'Task deleted!'
      redirect_to tasks_path
    else
      redirect_to @task
    end
  end

private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
