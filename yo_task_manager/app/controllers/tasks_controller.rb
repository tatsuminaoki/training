# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_user, only: %i[index create show edit update destroy]
  before_action :set_task, only: %i[show edit update destroy]
  before_action :user_is_logged_in

  def index
    @q = @user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])
  end

  def new
    @task = Task.new
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      flash[:success] = [t('.task_saved')]
      redirect_to tasks_path
    else
      flash[:danger] = [(t('something_is_wrong') + t('tasks.task_is_not_saved')).to_s, @task.errors.full_messages].flatten
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize

  def show; end

  def edit; end

  # rubocop:disable Metrics/AbcSize
  def update
    if @task.update(task_params)
      flash[:success] = [t('.task_updated')]
      redirect_to tasks_path
    else
      flash.now[:danger] = [(t('something_is_wrong') + t('tasks.task_is_not_updated')).to_s, @task.errors.full_messages].flatten
      render :edit
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    if @task.destroy
      flash[:success] = [t('.task_deleted')]
    else
      flash[:danger] = [(t('something_is_wrong') + t('tasks.task_is_not_destroyed')).to_s, @task.errors.full_messages].flatten
    end
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :body, :task_limit, :aasm_state)
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = [t('tasks.task_not_found')]
    redirect_to tasks_path
  end

  def set_user
    @user = current_user
  end
end
