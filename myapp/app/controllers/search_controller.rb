class SearchController < ApplicationController
  def index
    if params[:query].present?
      projects_list = Project.ransack(name_cont_any: params[:query].split).result
      tasks_list = Task.ransack(name_cont_any: params[:query].split).result
      tasks_list = adding_project_id_to_tasks_list(tasks_list)
    end
    render status: 200, json: { projects: projects_list, tasks: tasks_list}
  end

  private

  def adding_project_id_to_tasks_list(tasks_list)
    tasks_list_array = []
    tasks_list.map do |task|
      tasks_record = task.as_json
      tasks_record["group"] =  task.group
      tasks_record["project"] =  task.group.project
      tasks_list_array << tasks_record
    end
    tasks_list_array
  end
end
