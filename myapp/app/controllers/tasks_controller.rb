class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @params = params.require(:task).permit(:title, :description)
    @task = Task.new(@params)

    if @task.save
      # とりあえずリストに飛ばす
      redirect_to action: 'index'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end    
end
