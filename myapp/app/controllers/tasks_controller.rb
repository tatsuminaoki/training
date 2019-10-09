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
    # @TODO step16でユーザ登録機能を実装したら任意のユーザで登録するよう修正
    @task[:user_id] = 1
    if @task.save
      flash[:success] = 'Task is successfully created!'
      redirect_to task_path(@task.id)
    else
      flash[:fail] = 'Failed to create the task...'
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = 'Task is successfully updated!'
      redirect_to task_path(@task.id)
    else
      flash[:fail] = 'Failed to update the task...'
      render edit_task_url(@task.id)
    end
  end

  def destroy
  end

  private

    def task_params
      params.require(:task).permit(:title, :description, :priority, :status, :due_date)
    end
end
