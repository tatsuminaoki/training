class TasksController < ApplicationController
  before_action :is_my_task, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  PER = 10

  def index
    @search_params = task_search_params
    @user = User.find(@current_user.user_id)
    @tasks = Task.eager_load(:user)
      .where('users.id = ?', @current_user.user_id)
      .search(@search_params).order(sort_column + ' ' + sort_direction)
      .page(params[:page]).per(PER)
  end

  def show
    @task = Task.find(params[:id])
    @labels = Label.where(id: label_ids = TaskLabel.where(task_id: @task.id).select(:label_id))
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task[:user_id] = @current_user.user_id
    if @task.save
      @task.save_labels(params[:label].split(','))
      flash[:success] = t('flash.create.success')
      redirect_to task_path(@task.id)
    else
      flash.now[:danger] = t('flash.create.fail')
      render :new
    end
  end

  def edit
    @labels = Label.where(id: label_ids = TaskLabel.where(task_id: params[:id]).select(:label_id))
  end

  def update
    if @task.update(task_params) && @task.save_labels(params[:label].split(','))
      flash[:success] = t('flash.update.success')
      redirect_to task_path(@task.id)
    else
      flash.now[:danger] = t('flash.update.fail')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = t('flash.remove.success')
    else
      flash[:success] = t('flash.remove.fail')
    end
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date)
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status, :label)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? 'tasks.' + params[:sort] : 'tasks.created_at'
  end

  def is_my_task
    @task = Task.find(params[:id])
    redirect_to tasks_path unless @task[:user_id] == @current_user.user_id
  end
end
