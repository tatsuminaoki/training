class SearchController < ApplicationController
  def index
    projects_list, tasks_list = Search.search(params[:query], @current_user) if params[:query].present?
    render status: 200, json: { projects: projects_list, tasks: tasks_list}
  end
end
