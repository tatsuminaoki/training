# frozen_string_literal: true

class TaskLabelsController < ApplicationController
  before_action :find_task, only: %i[create destroy]

  def create
    @find_task.labels << Label.find_by!(id: params[:task_label][:label_id])
    if @find_task.save
      render status: 200, json: { task: @find_task, label: @find_task.labels.find_by!(id: params[:task_label][:label_id]) }
    else
      render status: 400, json: {}
    end
  end

  def destroy
    task_label = TaskLabel.find_by!(task_id: find_task.id, label_id: params[:task_label][:label_id])
    if task_label.delete
      render status: 200, json: { task: @find_task, label: Label.find_by!(id: params[:task_label][:label_id]) }
    else
      render status: 400, json: {}
    end
  end

  private

  def find_task
    @find_task ||= Task.find_by!(id: params[:task_label][:task_id])
  end
end
