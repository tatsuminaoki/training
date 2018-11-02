class ListController < ApplicationController
  before_action :all_labels, only: [:edit, :update, :new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Task.includes(task_label: :label).search(params: params, user: @user).page(params[:page])
    if sort_direction.present? && sort_column.present?
      @tasks = @tasks.order("#{sort_column}": sort_direction)
    else
      @tasks = @tasks.order(created_at: :desc)
    end
  end

  def new
    @task = Task.new
    @task.task_label.build
  end

  def edit
    @task = Task.find_by(id: params[:id], user_id: @user[:id])
    render action: 'new'
  end

  def create
    # TODO: バリデーション全くやってないので後でコーディングする
    @task_params = common_params
    @task_params[:user_id] = @user[:id]

    @task = Task.new(@task_params)
    result = @task.save

    # TODO: ここでlabelの保存する必要があるけど他のパートで実施する
    if result
      flash[:info] = make_simple_message(action: "new")
      redirect_to :action => 'index'
    else
      flash[:warning] = make_simple_message(action: "new", result: false)
      render action: 'new'
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id], user_id: @user[:id])
    result = @task.destroy

    if result
      flash[:info] = make_simple_message(action: "delete")
    else
      flash[:warning] = make_simple_message(action: "delete", result: false)
    end

    redirect_to :action => 'index'
  end

  def update
    @task = Task.find_by(id: params[:id], user_id: @user[:id])
    result = @task.update(common_params)

    if result
      flash[:info] = make_simple_message(action: "edit")
      redirect_to :action => 'index'
    else
      flash[:warning] = make_simple_message(action: "edit", result: false)
      render action: 'new'
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

  def make_simple_message(action:, result: true)
    result_str = "words.failure"
    result_str = "words.success" if result

    I18n.t("messages.simple_result",
      name: I18n.t("words.task"),
      action: I18n.t("actions.#{action}"),
      result: I18n.t(result_str))
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : ''
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : ''
  end
end
