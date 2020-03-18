class TaskLabelsController < ApplicationController
  before_action :find_task, only: [:create, :destroy]

  def create
    @task.labels << Label.find_by!(id: params[:task_label][:label_id])
    if @task.save
      render status: 200, json: { task: @task, labels: @task.labels }
    else
      render status: 400, json: {}
    end
  end

  def destroy
    if find_task.labels.delete(params[:task_label][:label_id])
      render status: 200, json: { task: find_task, labels: params[:task_label][:label_id] }
    else
      render status: 400, json: {}
    end
  end

  private

  def find_task
    @task ||= Task.find_by!(id: params[:task_label][:task_id])
  end
end
