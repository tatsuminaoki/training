# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_tasks_user
  before_action -> { correct_user(@tasks_user) }

  # GET /tasks
  def index
    @q = Task.includes(:user).includes(:taggings).
         where(user_id: @tasks_user.id).search_by_tag(params[:tag_name]).
         ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])
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
    @task = @tasks_user.tasks.new(task_params)

    if @task.save
      redirect_to [@tasks_user, @task], success: I18n.t('.flash.success.task.create')
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to [@tasks_user, @task], success: I18n.t('.flash.success.task.update')
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to user_tasks_path(@tasks_user), success: I18n.t('.flash.success.task.destroy')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :tag_list, :status, :description, :due_date)
  end

  def set_tasks_user
    @tasks_user = User.find(params[:user_id] || current_user.id)
  end
end
