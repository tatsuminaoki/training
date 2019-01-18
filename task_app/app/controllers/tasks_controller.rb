class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to root_url, flash: { success: "タスク「#{@task.name}」を登録しました。" }
    else
      flash[:danger] = "タスク「#{@task.name}」の登録に失敗しました。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_url, flash: { success: "タスク「#{@task.name}」を更新しました。" }
    else
      flash[:danger] = "タスク「#{@task.name}」の更新に失敗しました。"
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      redirect_to root_url, flash: { success: "タスク「#{@task.name}」を削除しました。" }
    else
      redirect_to root_url, flash: { danger: "タスク「#{@task.name}」の削除に失敗しました。" }
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
