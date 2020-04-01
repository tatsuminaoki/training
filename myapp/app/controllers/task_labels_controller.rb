class TaskLabelsController < ApplicationController
  before_action :find_task, only: [:create, :destroy]

  def create
    @task.labels << Label.find_by!(id: params[:task_label][:label_id])
    if @task.save
      render status: 200, json: { task: @task, label: @task.labels.find_by!(id: params[:task_label][:label_id]) }
    else
      render status: 400, json: {}
    end
  end

  def destroy
    task_label = TaskLabel.find_by!(task_id: find_task.id, label_id: params[:task_label][:label_id])
    if task_label.delete
      render status: 200, json: { task: @task, label: Label.find_by!(id: params[:task_label][:label_id]) }
    else
      render status: 400, json: {}
    end
  end

  private

  def find_task
    @task ||= Task.find_by!(id: params[:task_label][:task_id])
  end
end
