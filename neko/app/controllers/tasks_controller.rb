class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :get_stauses, only: [:new, :edit]

  def index
    @tasks = if sort_column == 'due_at'
      Task.all.order(have_a_due: :desc).order(sort_column + ' ' + sort_direction)
    elsif sort_column == 'status_id'
      Task.joins(:status).includes(:status).order('statuses.rate ' + sort_direction)
    else
      Task.all.order(sort_column + ' ' + sort_direction)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'タスクを作成しました'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'タスクの作成に失敗しました'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクを更新しました'
      redirect_to task_path(@task)
    else
      flash.now[:danger] = 'タスクの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = 'タスクを削除しました'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'タスクの削除に失敗しました'
      render :show
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def get_stauses
    @statuses = Status.all.order(rate: :asc)
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :have_a_due, :status_id)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
