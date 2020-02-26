class ProjectsController < ApplicationController
  def show
    @project = find_project
  end

  def index
    @projects = Project.all #TODO ユーザーが所属されているプロジェクのみ絞る
  end

  def create
    project = Project.new(request_params)
    if project.valid?
      project.create!
      redirect_to project_url(project.id), alert: 'Success to create project'
    else
      redirect_to projects_url, alert: 'Failed to create project'
    end
  end

  def update
    project = find_project
    project.update(request_params)
    render status: 200, json: {}
  end

  def destroy
    project = find_project
    project_name = project.name
    project.destroy
    redirect_to projects_url, alert: "Closed #{project_name} project"
  end

  private

  def find_project
    @project ||= Project.find_by(id: params[:id])
  end

  def request_params
    params.require(:project).permit(:name)
  end
end
