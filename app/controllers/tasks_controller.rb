# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index # rubocop:disable Metrics/AbcSize
    @tasks = if params[:commit].nil?
               current_user.tasks.all.page(params[:page])
             else
               current_user.tasks.name_like(params[:name]).
                          status(params[:status]).
                          page(params[:page])
             end

    @tasks = if params[:sort].present?
               @tasks.order(finished_on: params[:sort])
             else
               @tasks.order(created_at: :desc)
             end
  end

  def new
    # @task = Task.new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, success: t('messages.created', item: @task.model_name.human)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, success: t('messages.updated', item: @task.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy!
    redirect_to root_path, success: t('messages.deleted', item: @task.model_name.human)
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :status,
      :finished_on,
    )
  end
end
