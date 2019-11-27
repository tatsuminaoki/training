# frozen_string_literal: true

class TasksController < ApplicationController
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks/create
  def create
    @task = Task.new(task_params)
    return render :new unless @task.save
    flash[:success] = 'Success!'
    redirect_to tasks_path
  end

  # GET /tasks/:id/edit/
  def edit
    @task = Task.find(params[:id])
  end

  # PATCH /tasks/:id
  def update
    @task = Task.find(params[:id])
    return render :edit unless @task.update(task_params)
    flash[:success] = 'Success!'
    redirect_to tasks_path
  end

  # GET /tasks/:id
  def show
    @task = Task.find(params[:id])
  end

  # GET /tasks/
  def index
    @tasks = Task.all.order(sort_column => :desc)
  end

  # DELETE /task/:id
  def destroy
    @task = Task.find(params[:id])
    return unless @task.destroy
    flash[:success] = 'Deleted'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end

  def sort_column
    params.key?(:sort) ? params[:sort] : :created_at
  end
end
