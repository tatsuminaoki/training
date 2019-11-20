class TasksController < ApplicationController
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks/create
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "Success!"
      redirect_to tasks_path
    end
  end

  # GET /tasks/:id/edit/
  def edit
    @task = Task.find(params[:id])
  end

  # PATCH /tasks/:id
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "Success!"
      redirect_to tasks_path
    end
  end

  # GET /tasks/:id
  def show
    @task = Task.find(params[:id])
  end

  # GET /tasks/
  def index
    @tasks = Task.all
  end

  # DELETE /task/:id
  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:success] = "Deleted"
      redirect_to tasks_path
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
