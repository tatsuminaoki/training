class TasksController < ApplicationController
  include SortUtility

  before_action LoginFilter.new

  helper_method :sort_column, :sort_order

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @user = session[:user]
    sort = sort_column Task, 'created_at'
    order = sort_order
    label_models = get_labels

    @labels = Hash.new
    @labels.store(I18n.t('labels.all'), '0')
    label_models.each do |label|
      @labels.store(label.label, label.id)
    end

    @tasks = Task.order("#{sort} #{order}")

    # ログインユーザで絞込
    @tasks = @tasks.get_by_user_id(@user['id'])
    # ステータスが指定されていたら絞込
    if params[:status].present? && params[:status].to_i > 0
      @tasks = @tasks.get_by_status(params[:status])
    end

    # ラベルが指定されていたら絞込
    if params[:label].present? && params[:label].to_i > 0
      task_ids = TaskToLabel.where(label_id: params[:label].to_i).pluck(:task_id)
      @tasks = @tasks.where(id: task_ids)
    end

    # キーワードが指定されていたら絞込
    if params[:keyword].present?
      @tasks = @tasks.get_by_keyword(params[:keyword])
    end

    # Pagenation
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page])
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @labels = get_labels
  end

  # GET /tasks/1/edit
  def edit
    @labels = get_labels
  end

  # POST /tasks
  # POST /tasks.json
  def create
    user = session[:user]
    @task = Task.new(task_params)
    @task.user_id = user['id']

    respond_to do |format|
      if @task.save
        add_labels

        format.html { redirect_to @task, notice: t('notices.created', model: t('activerecord.models.task')) }
        format.json { render :show, status: :created, location: @task }
      else
        @labels = get_labels
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        add_labels

        format.html { redirect_to @task, notice: t('notices.updated', model: t('activerecord.models.task')) }
        format.json { render :show, status: :ok, location: @task }
      else
        @labels = get_labels
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('notices.deleted', model: t('activerecord.models.task')) }
      format.json { head :no_content }
    end
  end

  private
    # ユーザチェック
    def check_user
      user = session[:user]
      raise Forbidden if user['id'] != @task.user_id && !ActiveRecord::Type::Boolean.new.cast(user['admin_flag'])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def get_labels
      @labels = Label.where('user_id is null or user_id = ?', session[:user]['id'])
    end

    def add_labels
      TaskToLabel.where(task_id: @task.id).delete_all

      labels = params[:labels]
      if labels.present?
        labels.each do |label|
          TaskToLabel.create( task_id: @task.id, label_id: label.to_i )
        end
      end

      new_labels = params[:new_labels]
      if new_labels.present?
        new_labels.each do |new_label|
          label = Label.create(label: new_label, user_id: user_id = @task.user_id)
          TaskToLabel.create( task_id: @task.id, label_id: label.id )
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:user_id, :title, :description, :status, :priority, :due_date, :start_date, :finished_date)
    end
end
