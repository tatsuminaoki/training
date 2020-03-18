class TasksController < ApplicationController
  before_action :find_task, only: [:update, :destroy, :register_label, :remove_label ]

  def create
    task = Task.new(request_params)
    if task.save
      redirect_to project_url(id: params[:project_id]), alert: I18n.t('flash.success_create', model_name: 'task')
    else
      flash[:alert] = I18n.t('flash.failed_create', model_name: 'task')
      redirect_to project_url(id: params[:project_id]), notice: task.errors.full_messages

    end
  end

  def update
    @task.update(request_params)
    if @task.save
      redirect_to project_url(id: @task.group.project.id), alert: I18n.t('flash.success_updated', model_name: 'task')
    else
      flash[:alert] = I18n.t('flash.failed_update', model_name: 'task')
      redirect_to project_url(id: @task.group.project.id), notice: @task.errors.full_messages
    end
  end

  def destroy
    task_name = @task.name
    project_id = @task.group.project.id
    @task.destroy
    redirect_to project_url(id: project_id), alert: I18n.t('flash.success_destroy', target_name: task_name, model_name: 'task')
  end

  def register_label
    @task.labels << Label.find_by!(id: params[:task][:label_id])
    if @task.save
      render status: 200, json: { task: @task, labels: @task.labels }
    else
      render status: 400, json: {}
    end
  end

  def remove_label
    if find_task.labels.delete(params[:label_id])
      render status: 200, json: { task: find_task, labels: params[:label_id] }
    else
      render status: 400, json: {}
    end
  end

  private

  def find_task
    @task ||= Task.find_by!(id: params[:id])
  end

  def request_params
    params.require(:task).permit(:name, :description, :priority, :group_id, :end_period_at, :creator_name, :assignee_name)
  end
end
