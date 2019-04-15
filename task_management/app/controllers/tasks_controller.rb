class TasksController < ApplicationController

  def index
    task_name = params[:name]
    status_id = params[:status_id]
    # ページ件数
    items_limit = 5

    if task_name.present?
      @tasks = Task.where(task_name: task_name).page(params[:page]).per(items_limit)
    elsif status_id.present?
      @tasks = Task.where(status_id: status_id).page(params[:page]).per(items_limit)
    else
      @tasks = Task.page(params[:page]).per(items_limit)
    end
  end

  def new
    @task = Task.new
  end

  def show
    task_id = params[:id]
    @task = Task.find(task_id)
  end

  def edit
    task_id = params[:id]
    @task = Task.find(task_id)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "新規タスクを追加しました"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    task_id = params[:id]
    task = Task.find(task_id)
    @task = task.update(task_params)
    if @task
      flash[:notice] = "タスクを編集しました"
      redirect_to task_path(task_id)
    else
      render 'edit'
    end
  end

  def destroy
    task_id = params[:id]
    task = Task.find(task_id)
    task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to root_path
  end

  def task_params
    params.require(:task).permit(:task_name, :contents, :status_id)
  end

end
