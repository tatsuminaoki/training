class TasksController < ApplicationController
  before_action  :validation, only: [:create, :update]

  def index
    @title = 'タスクリスト'
    @tasks = Task.all
  end

  def show
    redirect_to tasks_url
  end

  def new
    @title = 'タスク作成'
    @task = Task.new
  end

  def create
    @task = Task.new(checked_task)

    @task.save!
    flash[:success] = '登録されました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '登録に失敗しました'
    render :new
  end

  def edit
    @title = 'タスク編集'
    @task = Task.find(checked_id)
  rescue => e
    logger.error e
    flash[:danger] = '存在しないタスクです'
    redirect_to tasks_url
  end

  def update
    @task = Task.find(checked_id)

    @task.update!(checked_task)
    flash[:success] = '更新されました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '更新に失敗しました'
    render :edit
  end

  def destroy
    @task = Task.find(checked_id)
    @task.destroy
    flash[:success] = '削除しました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '削除に失敗しました'
    redirect_to tasks_url
  end

  private

  def checked_id
    @id = params[:id].to_i

    if @id <= 0
      logger.error("値が不正:" + params[:id])
      raise
    end

    @id
  end

  def checked_task
    params.require(:task).permit(:title, :description)
  end

  def validation
    if checked_task[:title].blank?
      flash[:danger] = 'タイトルは必須入力です'
      redirect_back(fallback_location: root_path)
    end
  end
end
