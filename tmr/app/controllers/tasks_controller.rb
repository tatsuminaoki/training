class TasksController < ApplicationController
  include SortUtility

  before_action LoginFilter.new

  helper_method :sort_column, :sort_order

  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    user = session[:user]
    sort = sort_column Task, 'created_at'
    order = sort_order

    @tasks = Task.order("#{sort} #{order}")

    # ログインユーザで絞込
    @tasks = @tasks.get_by_user_id(user['id'])
    # ステータスが指定されていたら絞込
    if params[:status].present? && params[:status].to_i > 0
      @tasks = @tasks.get_by_status(params[:status])
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
    check_user
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    check_user
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t('notices.created', model: t('activerecord.models.task')) }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    check_user
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t('notices.updated', model: t('activerecord.models.task')) }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    check_user
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

      if user['id'] != @task.user_id
        raise Forbidden
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:user_id, :title, :description, :status, :priority, :due_date, :start_date, :finished_date)
    end
end
