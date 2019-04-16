class TasksController < ApplicationController
  helper_method :sort_column, :sort_order

  SORT = [
    'expire_date'
  ]

  ORDER = [
    'asc', 'desc'
  ]

  # 一覧
  def index
    # TODO: ページネーション STEP14
    @tasks = Task.all.order(order_params)
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
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('task.create.success')
      redirect_to root_url
    else
      render 'new'
    end

  end

  # 編集
  def edit
    @task = Task.find(params[:id])
  end

  # 保存 (from edit)
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = t('task.update.success')
      redirect_to root_url
    else
      render 'edit'
    end
  end

  # 削除
  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = t('task.delete.success')
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(
      :name, :content, :expire_date
    )
  end

  def search_params
    params.permit(
      :sort, :order
    )
  end

  def order_params
    "#{sort_column} #{sort_order}"
  end

  def sort_order
    order_value = search_params[:order].downcase if search_params[:order].present?
    ORDER.include?(order_value) ? order_value : 'desc'
  end

  def sort_column
    sort_value = search_params[:sort].downcase if search_params[:sort].present?
    SORT.include?(sort_value) ? sort_value : 'created_at'
  end
end
