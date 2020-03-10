class SearchController < ApplicationController
  def index
    projects_list = Project.ransack(name_matches: params[:query]).result
    tasks_list = Task.ransack(name_matches: params[:query]).result
    render status: 200, json: { projects: projects_list, tasks: tasks_list }
  end
end
