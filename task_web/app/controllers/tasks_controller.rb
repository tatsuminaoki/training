class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(get_params)
    if @task.save
      redirect_to tasks_path, notice: 'complete task creation.'
    else
      redirect_to tasks_path, error: 'fail to create task.'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(get_params)
      redirect_to tasks_path, notice: 'complete update.'
    else
      redirect_to tasks_path, error: 'fail to update.'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy!
      redirect_to tasks_path, notice: 'complete task deletion.'
    else
      redirect_to tasks_path, error: 'fail to delete.'
    end
  end


  private

  def get_params
    params.require(:task).permit(:name, :description)
  end

end
