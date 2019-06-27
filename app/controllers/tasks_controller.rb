# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :task, only: %i[show edit update destroy]

  def index # rubocop:disable Metrics/AbcSize
    relation = current_user.tasks.includes(task_labels: :label)

    if params[:commit].present?
      label_ids = params[:label_ids].reject(&:blank?)

      relation = relation.name_like(params[:name]).
                   status(params[:status])
      relation = relation.where(id: TaskLabel.label_id(label_ids).pluck(:task_id)) if label_ids.present?
    end
    relation = relation.page(params[:page])

    @tasks = if params[:sort].present?
               relation.order(finished_on: params[:sort])
             else
               relation.order(created_at: :desc)
             end
  end

  def new
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

  def task
    @task = current_user.tasks.includes(task_labels: :label).find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :status,
      :finished_on,
      label_ids: [],
    )
  end
end
