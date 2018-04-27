class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :set_label_list_without_comma, only: %i(create update)
  before_action :set_label_list_with_comma, only: %i(show edit)

  # GET /tasks
  # GET /tasks.json
  def index
    record_number = 5
    @tasks = Task.includes(:user).search(params, @current_user.id, record_number)
    @labels = Label.order(name: :asc)
    @tasks = Label.find(params[:label][:id]).tasks.includes(:user).page(params[:page]).per(record_number) if params[:label].present?
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
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        @task.save_labels(@label_list)
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
    if @current_user.id == @task.user_id
      respond_to do |format|
        if @task.update(task_params)
          @task.save_labels(@label_list)
          format.html { redirect_to @task, notice: t('flash.task.update') }
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:alert] = t('flash.user.different_task')
      render 'edit'
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    if @current_user.id == @task.user_id
      @task.destroy
      respond_to do |format|
        format.html { redirect_to tasks_url, notice: t('flash.task.destroy') }
        format.json { head :no_content }
      end
    else
      flash[:alert] = t('flash.user.different_task')
      render 'index'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :description, :due_date, :priority, :status, :user_id, :label_list)
  end

  def set_label_list_without_comma
    @label_list = params[:label_list].presence&.split(',') || []
  end

  def set_label_list_with_comma
    @label_list = @task.labels.pluck(:name).join(',')
  end
end
