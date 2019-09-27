class TasksController < ApplicationController
  def index
    @task = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'タスクが保存されました。'
    else
      flash.now[:danger] = '問題が発生しました。タスクが保存されていません。'
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def destroy
  end

  private
    def task_params
      params.require(:task).permit(:title, :body)
    end
end
