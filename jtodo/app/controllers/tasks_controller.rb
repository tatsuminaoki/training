class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.page(params[:page]).per(PAGE_PER)
    if params[:search].present?
      @tasks = @tasks.search(params[:search])
    end
    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end
    if Task.sortable.any? { |s| params[:sort] =~ /\A#{s}( desc)*\z/ }
      sort_param = params[:sort]
    else
      sort_param = :created_at
    end
    @tasks = @tasks.order(sort_param)
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      redirect_to @task
      flash[:success] = t('.success')
    else
      render :new
      flash[:danger] = t('.fail')
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task
      flash[:success] = t('.success')
    else
      render :edit
      flash[:danger] = t('.fail')
    end
  end

  # DELETE /tasks/1
  def destroy
    if @task.destroy
      redirect_to tasks_url
      flash[:success] = t('.success')
    else
      render @task
      flash[:danger] = t('.fail')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :priority, :status, :due_date)
    end
end
