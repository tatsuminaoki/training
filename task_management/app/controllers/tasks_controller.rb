class TasksController < ApplicationController
  def list
    @tasks = Task.all
  end

  def new_task
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to root_path
    else
      render 'new_task'
    end
  end

  def task_params
    params.require(:task).permit(:task_name, :contents)
  end

end
