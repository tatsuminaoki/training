class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)

    if @task.save
      flash[:success] = 'Taskは正常に作成されました'
      redirect_to tasks_path
    else
      render :new
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
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_path
  end

  private
    def task_params
      params.require(:task).permit(:title, :memo)
    end
end
