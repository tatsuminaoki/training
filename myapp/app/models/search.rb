class Search
  include Virtus.model
  class << self
    def search(query)
        projects_list = Project.ransack(name_cont_any: query.split).result
        tasks_list = Task.ransack(name_cont_any: query.split).result
        tasks_list = adding_project_and_group_to_task(tasks_list)

        return projects_list, tasks_list
    end

    private

    def adding_project_and_group_to_task(tasks_list)
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
end
