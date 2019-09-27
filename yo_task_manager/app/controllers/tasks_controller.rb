class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @task = Task.all.reverse
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'タスクが保存されました。'
      redirect_to tasks_path
    else
      flash.now[:danger] = '問題が発生しました。タスクが保存されていません。'
      render action: 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクが更新されました。'
      redirect_to tasks_path
    else
      flash.now[:danger] = '問題が発生しました。タスクが更新されていません。'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'タスクが削除されました。'
    else
      flash[:danger] = '問題が発生しました。タスクが削除されていません。'
    end
    redirect_to tasks_path
  end

  private
    def task_params
      params.require(:task).permit(:title, :body)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
