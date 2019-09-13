# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(self.get_resource_params)
    if @task.save
      redirect_to task_path(@task.id), flash: {success: 'タスクを作成しました。'}
    else
      render :new
    end
  end

  def show
    @task = self.find_resource
  end

  def edit
    @task = self.find_resource
  end

  def update
    @task = self.find_resource
    if @task.update(self.get_resource_params)
      redirect_to task_path(@task.id), flash: {success: 'タスクを更新しました。'}
    else
      render :new
    end
  end

  def destroy
    @task = self.find_resource
    if @task.destroy
      redirect_to tasks_path, flash: {success: "タスクを削除しました。 id=#{@task.id}"}
    else
      redirect_to task_path(@task.id), flash: {error: "タスクの削除に削除しました。 id=#{@task.id}"}
    end
  end

  protected

  def find_resource
    Task.find(params[:id])
  end

  def get_resource_params
    params.require(:task).permit(:name, :detail)
  end
end
