class Admin::UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  PER = 20

  def index
    @users = User.preload(:tasks).page(params[:page]).per(PER)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date)
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status)
  end

  # def sort_direction
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  # end

  # def sort_column
  #   Task.column_names.include?(params[:sort]) ? 'tasks.' + params[:sort] : 'tasks.created_at'
  # end
end
