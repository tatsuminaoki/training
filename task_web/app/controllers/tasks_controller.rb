# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :all_labels, only: %w[edit update new create index]

  def index
    @tasks = current_user.tasks.includes(task_labels: :label).search(params).page(params[:page])
  end

  def show
    @task = current_user.tasks.includes(task_labels: :label).find(params[:id])
  end

  def new
    @task = current_user.tasks.new
    @task.task_labels.build
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: create_message('create', 'success')
    else
      flash[:error] = create_message('create', 'error')
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: create_message('update', 'success')
    else
      flash[:error] = create_message('update', 'error')
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    if @task.destroy
      redirect_to tasks_path, notice: create_message('delete', 'success')
    else
      redirect_to tasks_path, alert: create_message('delete', 'error')
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :priority, :due_date, :status, :label_ids, label_ids: [])
  end

  def create_message(action, result)
    I18n.t('messages.action_result', target: I18n.t('activerecord.models.task'), action: I18n.t("actions.#{action}"), result: I18n.t("results.#{result}"))
  end
end
