class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @search_params = task_search_params
    @tasks = Task.all.search(@search_params).order(sort_column + ' ' + sort_direction)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    # @TODO step16でユーザ登録機能を実装したら任意のユーザで登録するよう修正
    @task[:user_id] = 1
    if @task.save
      flash[:success] = t('flash.create.success')
      redirect_to task_path(@task.id)
    else
      flash[:fail] = t('flash.create.fail')
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = t('flash.update.success')
      redirect_to task_path(@task.id)
    else
      flash[:fail] = t('flash.update.fail')
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
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
      params.fetch(:search, {}).permit(:title, :status)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def sort_column
      Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end
end
