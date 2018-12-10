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
    @task = Task.new(common_params)
    if @task.save
      redirect_to tasks_path, notice: 'タスクを登録しました'
     else
      flash[:error] = 'タスクの登録に失敗しました'
      render file: "tasks/new", contents_type: 'text/html'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(common_params)
      redirect_to tasks_path, notice: 'タスクを更新しました'
    else
      flash[:error] = 'タスクの更新に失敗しました'
      render file: "tasks/edit", contents_type: 'text/html'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_path, notice: 'タスクを削除しました'
    else
      redirect_to tasks_path, error: 'タスクの削除に失敗しました'
    end
  end

  private

  def common_params
    params.require(:task).permit(:name, :description)
  end

end
