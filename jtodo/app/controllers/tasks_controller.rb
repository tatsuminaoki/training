class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.all.includes(:labels)
    @labels = current_user_all_labels(@tasks)
    @tasks = @tasks.page(params[:page]).per(PAGE_PER)
    if params[:search].present?
      @tasks = @tasks.search(params[:search])
    end

    if params[:status].present?
      @tasks = @tasks.where(status: params[:status])
    end

    if params[:label].present?
      @tasks = @tasks.where(task_labels: {label_id: params[:label]})
    end

    if Task.sortable.any? { |s| params[:sort] =~ /\A#{s}( desc)*\z/ }
      sort_param = params[:sort]
    else
      sort_param = :created_at
    end

    @tasks = @tasks.order(sort_param)
  end

  # GET /tasks/1
  def show
    @task.set_label_names
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    @task.set_label_names
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      if @task.update_labels
        flash[:success] = t('.success')
        redirect_to @task
      else
        flash[:danger] = t('.fail_update_labels')
      end

    else
      flash[:danger] = t('.fail')
      render :new
    end

  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      if @task.update_labels
        flash[:success] = t('.success')
        redirect_to @task
      else
        flash[:danger] = t('.fail_update_labels')
      end

    else
      flash[:danger] = t('.fail')
      render :edit
    end

  end

  # DELETE /tasks/1
  def destroy
    if @task.destroy
      flash[:success] = t('.success')
      redirect_to tasks_url
    else
      flash[:danger] = t('.fail')
      render @task
    end

  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date, :label_names)
  end

  def current_user_all_labels(tasks)
    all_labels = []
    tasks.each do |task|
      task.labels.each do |label|
        all_labels << label if label.present?
      end
    end
    return all_labels.uniq
  end

end
