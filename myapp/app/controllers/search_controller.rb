class SearchController < ApplicationController
  def index
    projects_list = Project.ransack(name_matches: params[:query]).result
    tasks_list = Task.ransack(name_matches: params[:query]).result
    tasks_list = adding_project_id_to_tasks_list(tasks_list)
    render status: 200, json: { projects: projects_list, tasks: tasks_list}
  end

  private

  def adding_project_id_to_tasks_list(tasks_list)
    tasks_list_array = []
    tasks_list.map do |task|
      tasks_record = task.as_json
      tasks_record["project_id"] =  task.group.project.id
      tasks_list_array << tasks_record
    end
    tasks_list_array
  end
end
