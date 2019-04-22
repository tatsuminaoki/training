class TasksController < ApplicationController
  helper_method :sort_column, :sort_order

  before_action :logged_in_user
  before_action :ensure_task_owner!, only: [:show, :edit, :update, :destroy]

  # 一覧
  def index
    @search_task = SearchTask.new(params, current_user.id)
    @tasks = @search_task.execute()
  end

  # 詳細
  def show
    @task = Task.find(params[:id])
  end

  # 新規作成
  def new
    @task = Task.new
  end

  # 保存 (from new)
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = t('task.create.success')
      redirect_to root_url
    else
      render 'new'
    end
  end

  # 編集
  def edit
  end

  # 保存 (from edit)
  def update
    if @task.update_attributes(task_params)
      flash[:success] = t('task.update.success')
      redirect_to root_url
    else
      render 'edit'
    end
  end

  # 削除
  def destroy
    @task.destroy
    flash[:success] = t('task.delete.success')
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(
      :name, :content, :expire_date, :status
    )
  end

  def sort_order
    @search_task.sort_order
  end

  def sort_column
    @search_task.sort_column
  end

  def logged_in_user
    store_location

    unless logged_in?
      flash[:danger] = t('session.login.not_login')
      redirect_to login_url
    end
  end

  def ensure_task_owner!
    task = Task.where(id: params[:id]).where(user_id: current_user.id)
    redirect_to(root_url) unless task.present?

    @task = task.first()
  end
end
