class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all.reverse
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('.task_saved')
      redirect_to tasks_path
    else
      flash.now[:danger] = '問題が発生しました。タスクが保存されていません。'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = t('.task_updated')
      redirect_to tasks_path
    else
      flash.now[:danger] = '問題が発生しました。タスクが更新されていません。'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('.task_deleted')
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
