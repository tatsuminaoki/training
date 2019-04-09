class TasksController < ApplicationController
  def list
    @tasks = Task.all
  end

  def new_task
    @task = Task.new
  end

  def detail_task
    task_id = params[:task_id]
    @task = Task.find(task_id)
  end

  def edit_task
    task_id = params[:task_id]
    @task = Task.find(task_id)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "新規タスクを追加しました"
      redirect_to root_path
    else
      render 'new_task'
    end
  end

  def update
    task_id = params[:id]
    task = Task.find(task_id)
    @task = task.update(task_params)
    if @task
      flash[:notice] = "タスクを編集しました"
      redirect_to detail_task_path(task_id)
    else
      render 'edit_task'
    end
  end

  def task_params
    params.require(:task).permit(:task_name, :contents)
  end

end
