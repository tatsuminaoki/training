class SearchController < ApplicationController
  def index
    projects_list, tasks_list = Search.find_by_name(params[:query]) if params[:query].present?
    render status: 200, json: { projects: projects_list, tasks: tasks_list}
  end
end
