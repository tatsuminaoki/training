class TasksController < ApplicationController
  before_action :find_task, only: [:update, :destroy]

  def create
    task = Task.new(request_params)
    if task.save
      redirect_to project_url(id: params[:task][:project_id]), alert: 'Success to create task'
    else
      redirect_to project_url(id: params[:task][:project_id]), alert: 'Failed to create task'
    end
  end

  def update
    @task.update(request_params)
    if @task.save
      redirect_to project_url(id: @task.group.project.id), alert: 'Success to update task'
    else
      redirect_to project_url(id: @task.group.project.id), alert: 'Failed to update task'
    end
  end


  def destroy
    task_name = @task.name
    project_id = @task.group.project.id
    @task.destroy!
    redirect_to project_url(id: project_id), alert: "Deleted #{task_name} task"
  end


  private

  def find_task
    @task ||= Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # TODO エラーページ追加
    redirect_to projects_url, status: 500, alert: 'Not found task'
  end

  def request_params
    params.require(:task).permit(:name, :description, :priority, :group_id)
  end
end
