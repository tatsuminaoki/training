class TasksController < ApplicationController
  before_action :find_task, only: [:update, :destroy]

  def create
    task = Task.new(request_params)
    if task.valid?
      task.save
      redirect_to project_url(id: params[:task][:project_id]), alert: 'Success to create task'
    else
      redirect_to project_url(id: params[:task][:project_id]), alert: 'Failed to create task'
    end
  end

  def update
    @task.update(request_params)
    redirect_to project_url(id: @task.group.project.id), alert: 'Success to update task'
  end


  def destroy
    task_name = @task.name
    project_id = @task.group.project.id
    @task.destroy
    redirect_to project_url(id: project_id), alert: "Deleted #{task_name} task"
  end


  private

  def find_task
    @task ||= Task.find_by(id: params[:id])
  end

  def request_params
    params.require(:task).permit(:name, :description, :priority, :group_id)
  end
end
