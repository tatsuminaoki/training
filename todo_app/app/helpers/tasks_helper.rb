module TasksHelper
  def submit_btn_name
    if request.path_info == new_task_path
      return I18n.t('helpers.submit.create')
    else
      return I18n.t('helpers.submit.update')
    end
  end

  def status_pull_down
    Task.statuses.keys.map { |key| [Task.human_attribute_name("status.#{key}"), key]}
  end

  def priority_pull_down
    Task.priorities.keys.map { |key| [Task.human_attribute_name("priority.#{key}"), key]}
  end

  def status_value(key)
    Task.human_attribute_name("status.#{key}")
  end

  def priority_value(key)
    Task.human_attribute_name("priority.#{key}")
  end
end
