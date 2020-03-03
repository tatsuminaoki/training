class TasksController < ApplicationController
  before_action :find_task, only: [:update, :destroy]

  def create
    task = Task.new(request_params)
    if task.valid?
      task.save
      redirect_to project_url(id: params[:task][:project_id]), alert: I18n.t('flash.success_create', model_name: 'task')
    else
      redirect_to project_url(id: params[:task][:project_id]), alert: I18n.t('flash.failed_create', model_name: 'task')
    end
  end

  def update
    @task.update(request_params)
    if @task.valid?
      @task.save
      redirect_to project_url(id: @task.group.project.id), alert: I18n.t('flash.success_updated', model_name: 'task')
    else
      redirect_to project_url(id: @task.group.project.id), alert: I18n.t('flash.failed_update', model_name: 'task')
    end
  end


  def destroy
    task_name = @task.name
    project_id = @task.group.project.id
    @task.destroy
    redirect_to project_url(id: project_id), alert: I18n.t('flash.success_destroy', model_name: 'task')
  end


  private

  def find_task
    @task ||= Task.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    # TODO エラーページ追加
    redirect_to projects_url, status: 500, alert: I18n.t('error.record_not_found', data: 'task')
  end

  def request_params
    params.require(:task).permit(:name, :description, :priority, :group_id)
  end
end
