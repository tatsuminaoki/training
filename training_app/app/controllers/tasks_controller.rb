# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  ITEM_PER_PAGE = 25

  # GET /tasks
  # GET /tasks.json
  def index
    @q = Task
      .preload(:user)
      .eager_load(:labels)
      .ransack(params[:q])

    @tasks = @q
      .result
      .where(user_id: current_user.id)
      .order(created_at: :desc)
      .page(params[:page])
      .per(ITEM_PER_PAGE)

    respond_to do |format|
      format.html { }
      format.json { render handlers: 'jbuilder' }
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

    Task.transaction do
      @task.user = current_user
      @task.labels = label_from_params
      @task.save!

      respond_to do |format|
        format.html { redirect_to @task, notice: t('tasks.new.create') }
        format.json { render :show, status: :created, location: @task }
      end
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    Task.transaction do
      @task.labels = label_from_params
      @task.update!(task_params)

      respond_to do |format|
        format.html { redirect_to @task, notice: t('tasks.edit.update') }
        format.json { render :show, status: :created, location: @task }
      end
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback
    respond_to do |format|
      format.html { render :new }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('tasks.index.destroy') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = current_user
      .tasks
      .find(params[:id])

    @task.label = @task.labels.map(&:name).join(',')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :body, :status, :label)
  end

  def label_from_params
    params[:task][:label]
      &.split(',')
      &.map(&:strip)
      &.filter(&:present?)
      &.map { |name| Label.find_or_initialize_by(name: name) }
  end
end
