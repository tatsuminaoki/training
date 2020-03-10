class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :update, :destroy]

  def show
  end

  def index
    @projects = Project.all # TODO ユーザーが所属されているプロジェクのみ絞る
  end

  def create
    project = Project.new(request_params)
    if project.valid?
      project.create!
      redirect_to project_url(project.id) ,alert: 'Success to create project'
    else
      redirect_to projects_url, alert: 'Failed to create project'
    end
  end

  def update
    @project.update(request_params)
    if @project.save
      render status: 200, json: {}
    else
      render status: 400, json: {}
    end
  end

  def destroy
    project_name = @project.name
    @project.destroy
    redirect_to projects_url, alert: "Closed #{project_name} project"
  end

  private

  def find_project
    @project ||= Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # TODO エラーページ追加
    redirect_to projects_url, status: 500, alert: 'Not found project'
  end

  def request_params
    params.require(:project).permit(:name)
  end
end
