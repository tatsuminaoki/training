class TasksController < ApplicationController
  protect_from_forgery except: :new
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end
  
  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
    if @task.save
      redirect_to ({action: 'index'}), notice: 'タスクを登録しました'
    else
      redirect_to ({action: 'new'}), alert: 'タスクの登録に失敗しました'
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      redirect_to ({action: 'show'}), id: params[:id], notice: 'タスクを更新しました'
    else
      redirect_to ({action: 'edit'}), alert: 'タスクの更新に失敗しました'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to ({action: 'index'}), notice: "タスク：#{@task.task_name}を削除しました"
    else
      redirect_to ({action: 'show'}), id: params[:id], alert: "タスク：#{@task.task_name}の削除に失敗しました"
    end
  end

  def tasks_params
    params.require(:task).permit(:task_name,:description)
  end
end
