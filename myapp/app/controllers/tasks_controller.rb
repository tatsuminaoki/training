class TasksController < ApplicationController
  def index
    @tasks = Task.all
    @status = ['Open', 'In Progress', 'Closed']
    @priority = ['Low', 'Middle', 'High']
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task[:user_id] = 1
    @task[:status] = 0
    if @task.save
      flash[:success] = 'Task created!'
      redirect_to tasks_new_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def task_params
      params.require(:task).permit(:title, :description, :priority, :due_date)
    end
end
