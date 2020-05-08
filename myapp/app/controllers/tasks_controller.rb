class TasksController < ApplicationController
  before_action :task_val , only: [:index, :sort]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Taskは正常に作成されました'
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'Taskは正常に更新されました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
    redirect_to tasks_path, notice: 'Taskは正常に削除されました'
  end

  def sort
    if params[:created_at].present?
      @created_at_num = params[:created_at].to_i
      if @created_at_num == 0
        @tasks = Task.order(created_at: :DESC)
        @created_at_num = 1
      else
        @tasks = Task.order(created_at: :ASC)
        @created_at_num = 0
      end
    elsif params[:title].present?
      @title_num = params[:title].to_i
      if @title_num == 0
        @tasks = Task.order(title: :DESC)
        @title_num = 1
      else
        @tasks = Task.order(title: :ASC)
        @title_num = 0
      end
    elsif params[:memo].present?
      @memo_num = params[:memo].to_i
      if @memo_num == 0
        @tasks = Task.order(memo: :DESC)
        @memo_num = 1
      else
        @tasks = Task.order(memo: :ASC)
        @memo_num = 0
      end
    else
      @tasks = Task.all
    end
    render :index
  end

  private
    def task_params
      params.require(:task).permit(:title, :memo)
    end
    
    def task_val
      @created_at_num = 0
      @title_num = 0
      @memo_num = 0
    end

end
