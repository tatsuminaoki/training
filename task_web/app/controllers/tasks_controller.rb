# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(common_params)
    if @task.save
      redirect_to tasks_path, notice: create_message('create', 'success')
    else
      flash[:error] = create_message('create', 'error')
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(common_params)
      redirect_to tasks_path, notice: create_message('update', 'success')
    else
      flash[:error] = create_message('update', 'error')
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_path, notice: create_message('delete', 'success')
    else
      redirect_to tasks_path, error: create_message('delete', 'error')
    end
  end

  private

  def common_params
    params.require(:task).permit(:name, :description)
  end

  def create_message(action, result)
    I18n.t('messages.action_result', target: I18n.t('activerecord.models.task'), action: I18n.t("actions.#{action}"), result: I18n.t("results.#{result}"))
  end
end
