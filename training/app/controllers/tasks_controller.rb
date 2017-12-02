class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  # todo page移動ボタンの実装

  def show
    @task = Task.find(params[:id])
  end

  def edit
    # todo 編集画面の実装
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.create_task(task_params)
    if @task.present?
      redirect_to @task, notice: '作成しました'
      # todo flashの実装
    else
      render :new
      # todo 異常系のテスト
    end
  end

  private

  def task_params
    params.require(:task).permit(
      :name, :description
    )
  end
end
