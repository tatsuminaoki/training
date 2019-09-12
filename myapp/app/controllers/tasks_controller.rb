class TasksController < ApplicationController
  def index
    @title = 'タスクリスト'
    @tasks = Task.all
  end

  def show
  end

  def new
    @title = 'タスク作成'
    @task = Task.new
  end

  def create
    @task = Task.new(checked_task)

    begin
      @task.save
      flash[:success] = '登録されました'
      redirect_to action: 'index'
    rescue => e
      logger.error e
      flash[:danger] = '登録に失敗しました'
      render :new
    end
  end

  def edit
    @title = 'タスク編集'
    begin
      @task = Task.find(checked_id)
    rescue => e
      logger.error e
      redirect_to action: 'index'
      return
    end
  end

  def update
    @task = Task.find(checked_id)

    begin
      @task.update(checked_task)
      flash[:success] = '更新されました'
      redirect_to action: 'index'
    rescue => e
      logger.error e
      flash[:danger] = '更新に失敗しました'
      render :new
    end
  end

  def destroy
  end

  private

  def checked_id
    @id = params[:id].to_i

    if @id <= 0
      # 値が不正
      logger.debug("値が不正:" + @id.to_s)
      redirect_to action: 'index'
      return
    end

    @id
  end

  def checked_task
    params.require(:task).permit(:title, :description)
  end
end
