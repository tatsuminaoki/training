class TasksController < ApplicationController
  SORT = [
    "expire_date"
  ]

  ORDER = [
    "asc", "desc"
  ]

  # 一覧
  def index
    # TODO: ページネーション STEP14
    @tasks = Task.all.order(search_order_sql)
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
      # TODO: Validation 対応後チェック
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
      # TODO: Validation 対応後チェック
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

  # TODO: 検索条件モデルを作成し、バリデートもそちらに委譲したい気持ち
  def search_order_sql
    search_condition = search_params
    sort_value = search_condition[:sort].downcase if search_condition[:sort].present?
    order_value = search_condition[:order].downcase if search_condition[:order].present?
    if SORT.include?(sort_value) && ORDER.include?(order_value)
      "#{search_condition[:sort]} #{search_condition[:order]}"
    else
      "created_at desc"
    end
  end
end
