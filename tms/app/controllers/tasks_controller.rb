class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  PER = 5 #Number of records per page

  # GET /tasks
  # GET /tasks.json
  def index
    if params[:due_date_desc] == 'true'
      @tasks = Task.all.order(due_date: :desc)
      @due_date_desc = 'true'
    elsif params[:due_date_desc] == 'false'
      @tasks = Task.all.order(due_date: :asc)
      @due_date_desc = 'false'
    elsif params[:priority_desc] == 'true'
      @tasks = Task.all.order(priority: :desc)
      @priority_desc = 'true'
    elsif params[:priority_desc] == 'false'
      @tasks = Task.all.order(priority: :asc)
      @priority_desc = 'false'
    else
      if params[:status].present?
        @tasks = Task.where(status: params[:status]).order(created_at: :desc)
      else
        if params[:title].present?
          @tasks = Task.where('title like ?', '%'+params[:title]+'%').order(created_at: :desc)
        else
          @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(PER)
        end
      end
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
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
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t('flash.task.create') }
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
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t('flash.task.update') }
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
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('flash.task.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :status, :user_id)
    end
end
