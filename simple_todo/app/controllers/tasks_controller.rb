class TasksController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  TASKS_PER_PAGE = 8

  def index
    @labels = Label.all
    @tasks = Task.all.user_search(session[:user_id]).includes(:user)
    if params[:title].present?
      @tasks = @tasks.title_search(params[:title])
    end
    if params[:status].present?
      @tasks = @tasks.status_search(params[:status])
    end
    if params[:label_id].present?
      @tasks = @tasks.label_search(params[:label_id])
    end
    @tasks = @tasks.page(params[:page]).order(created_at: :desc).per(TASKS_PER_PAGE)
  end

  def show
  end

  def new
    @labels = Label.all
    @task = Task.new
  end

  def edit
    @labels = Label.all
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t('flash.task.created')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.task.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.task.destroyed')
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :user_id, :limit, :priority, :status, {:label_ids => []})
    end

    def require_login
      unless user_signed_in?
        redirect_to login_path, notice: t('messages.plz_login')
      end
    end
end
