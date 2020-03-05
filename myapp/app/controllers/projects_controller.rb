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
      redirect_to project_url(project.id), alert: I18n.t('flash.success_create', model_name: 'project')
    else
      flash[:alert] = I18n.t('flash.failed_create', model_name: 'project')
      redirect_to projects_url, notice: project.errors.full_messages

    end
  end

  def update
    @project.update(request_params)
    if @project.valid?
      @project.save
      render status: 200, json: {}
    else
      render status: 400, json: {}
    end
  end

  def destroy
    project_name = @project.name
    @project.destroy
    redirect_to projects_url, alert: I18n.t('flash.success_destroy', model_name: 'project')
  end

  private

  def find_project
    @project ||= Project.find_by!(id: params[:id])
  end

  def request_params
    params.require(:project).permit(:name)
  end
end
