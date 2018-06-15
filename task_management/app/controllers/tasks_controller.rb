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
  end

  def create
    @task = Task.new(tasks_params)
    if @task.save
      flash[:notice] = 'タスクを登録しました'
      redirect_to :action => "index"
    else
      flash[:alert] = 'タスクの登録に失敗しました'
      render :action => "new"
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(tasks_params)
      flash[:notice] = 'タスクを更新しました'
      redirect_to :action => "show", id: params[:id]
    else
      flash[:alert] = 'タスクの更新に失敗しました'
      render :action => "edit"
    end
  end

  def tasks_params
    params.require(:task).permit(:task_name,:description)
  end
end
