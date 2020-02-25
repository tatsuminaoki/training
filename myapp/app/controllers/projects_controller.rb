class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def create
    project = Project.new(create_params)
    redirect_to controller: 'projects', action: 'show', id: project.id
  end

  def update
  end

  def show
    @projects = Project.all
  end

  def delete
  end

  private

  def create_params
    params.permit(:name)
  end
end
