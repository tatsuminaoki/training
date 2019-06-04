# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    if params[:commit].nil?
      @tasks = Task.all.page(params[:page])
    else
      @tasks = Task.name_like(params[:name]).
                 status(params[:status]).
                 page(params[:page])
    end

    if params[:sort].present?
      @tasks = @tasks.order(created_at: params[:sort])
    else
      @tasks = @tasks.order(created_at: :desc)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, success: t('messages.created', item: @task.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, success: t('messages.updated', item: @task.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @task.destroy!
    respond_to do |format|
      format.html { redirect_to root_path, success: t('messages.deleted', item: @task.model_name.human) }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :status,
    )
  end
end
