class ListController < ApplicationController
  before_action :all_labels, only: [:edit, :update, :new, :create]

  def index
    @tasks = Task.includes(task_label: :label)
  end

  def new
    @task = Task.new
    @task.task_label.build
  end

  def edit
    @task = Task.find(params[:id])
    render action: 'new'
  end

  def create
    # TODO: バリデーション全くやってないので後でコーディングする
    @task_params = common_params
    # TODO: session管理する必要がある(session管理するまで固定する)
    @task_params[:user_id] = 1

    @task = Task.new(@task_params)
    if @task.valid?
      # TODO: ここでlabelの保存する必要があるけど他のパートで実施する
      if @task.save
        flash[:notice] = make_simple_message("new","success")
        return redirect_to :action => 'index'
      end
    end
    flash[:warn] = make_simple_message("new","failure")
    render action: 'new'
  end

  def destroy
    @task = Task.find(params[:id])
    result = @task.destroy

    if result
      flash[:notice] = make_simple_message("delete","success")
    else
      flash[:warn] = make_simple_message("delete","failure")
    end

    redirect_to :action => 'index'
  end

  def update
    @task = Task.find(params[:id])
    result = @task.update(common_params)

    if result
      flash[:notice] = make_simple_message("edit","success")
      redirect_to :action => 'index'
    else
      flash[:warn] = make_simple_message("edit","failure")
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

  def make_simple_message(action, result)
    t "messages.simple_result",
      name: t("words.task"),
      action: t("actions.#{action}"),
      result: t("words.#{result}")
  end
end
