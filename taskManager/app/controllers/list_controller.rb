class ListController < ApplicationController
  before_action :all_labels, only: [:entry, :edit]

  def index
    @tasks = Task.includes(task_label: :label)
  end

  def entry
    @task = Task.new
    @task.task_label.build
  end

  def edit
    @task = Task.find(params[:id])

    render action: 'entry'
  end

  def insert
    # TODO: バリデーション全くやってないので後でコーディングする
    @task_params = common_params
    # TODO: session管理する必要がある(session管理するまで固定する)
    @task_params[:user_id] = 1

    @task = Task.new(@task_params)
    saved = @task.save!

    # TODO: ここでlabelの保存する必要があるけど他のパートで実施する
    if saved
      flash[:notice] = 'タスクの登録が完了しました。'
      redirect_to :action => 'index'
    else
      flash[:warn] = 'タスクの登録に失敗しました。'
      render action: 'entry'
    end
  end

  def delete
    @id = params[:id]
    @task = Task.find(@id)
    deleted = @task.destroy

    if deleted
      flash[:notice] = 'タスクの削除が完了しました。'
    else
      flash[:warn] = 'タスクの削除に失敗しました。'
    end

    redirect_to :action => 'index'
  end

  def update
    @task = Task.find(params[:id])
    updated = @task.update(common_params)

    if updated
      flash[:notice] = 'タスクの変更が完了しました。'
      redirect_to :action => 'index'
    else
      flash[:warn] = 'タスクの変更に失敗しました。'
      render action: 'edit'
    end
  end

  private

  def all_labels
    @label = Label.all
  end

  def common_params
    params.require(:task).permit(
      :task_name, :description, :deadline, :priority, :status,
      task_label_attributes: [:label_id]
    )
  end
end
