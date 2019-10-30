class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new

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
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:message] = 'Task updated!'
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:message] = 'Task deleted!'
    redirect_to tasks_path
  end

  private

    def task_params
      params.require(:task).permit(:name, :description)
    end
end
