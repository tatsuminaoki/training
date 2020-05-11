class TasksController < ApplicationController
  ALLOWED_NAME = %w(title memo created_at
                    title\ desc memo\ desc created_at\ desc).freeze

  def index
    p ALLOWED_NAME
    sort = params[:sort] if ALLOWED_NAME.include?(params[:sort])
    @tasks = Task.all.order(sort)
    p sort
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Taskは正常に作成されました'
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
      redirect_to task_path(@task), notice: 'Taskは正常に更新されました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
    redirect_to tasks_path, notice: 'Taskは正常に削除されました'
  end

  private
    def task_params
      params.require(:task).permit(:title, :memo)
    end
    
end
