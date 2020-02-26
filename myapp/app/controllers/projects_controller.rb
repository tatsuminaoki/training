class ProjectsController < ApplicationController
  def show
    @projects = Project.find_by(id: params[:id])
  end

  def index
    @projects = Project.all #TODO ユーザーが所属されているプロジェクのみ絞る
  end

  def create
    project = Project.new(create_params)
    if project.valid?
      project.create!
      redirect_to project_url(project.id), notice: 'Success create project'
    else
      redirect_to projects_url, alert: 'Failed create project'
    end
  end

  def update
  end

  def delete
  end

  private

  def create_params
    params.require(:project).permit(:name)
  end
end
