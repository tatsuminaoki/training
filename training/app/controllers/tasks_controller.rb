class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.create_task(task_params)
    if @task.present?
      redirect_to @task, notice: '作成しました'
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:task).permit(
      :name, :description
    )
  end
end
