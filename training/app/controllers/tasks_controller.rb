class TasksController < ApplicationController
  before_action :convert_params_to_enum

  def index
    @name = params[:name]
    @status = params[:status]
    @order = params[:order]

    @tasks = search(params)
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: I18n.t('tasks.controller.messages.created')
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      redirect_to @task, notice: I18n.t('tasks.controller.messages.updated')
    else
      render :edit
    end
  end

  def destroy
    Task.find(params[:id]).destroy!
    redirect_to tasks_path, notice: I18n.t('tasks.controller.messages.deleted')
  end

  private

  def task_params
    params.require(:task).permit(
      :user_id,
      :name,
      :description,
      :priority,
      :status,
      :label_id,
      :end_date,
    )
  end

  def search(params)
    result = Task
    result = result.where('status = ?', params[:status]) if params[:status].present?
    result = result.where('name = ?', params[:name]) if params[:name].present?

    # memo : 初回読み込み時にorderがnilでinclude?が実行できないので先にpresent?で確認
    #      : 現状ではend_dateのみなのでinclude?使わなくても判定できるが
    #      : 次のstepで優先順位検索を実装する時の為にあえてinclude?を利用（step15実装時にこのメモを消す）
    result = if params[:order].present? && params[:order].include?('end_date')
               order_option = params[:order] == 'end_date_asc' ? :asc : :desc
               result.order(end_date: order_option)
             else
               result.order(created_at: :desc)
             end
  end

  def convert_params_to_enum
    return false if params[:task].nil?
    params[:task][:status] = Integer(params[:task][:status]) if params[:task][:status].present?
  rescue ArgumentError
    return false
  end
end
