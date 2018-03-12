module TasksHelper
  def submit_btn_name
    if request.path_info == new_task_path
      return I18n.t('helpers.submit.create')
    else
      return I18n.t('helpers.submit.update')
    end
  end

  def status_pull_down
    Task.statuses.keys.map { |key| [status_value(key), key]}
  end

  def priority_pull_down
    Task.priorities.keys.map { |key| [priority_value(key), key]}
  end

  def sort_pull_down
    I18n.t('page.sort.type').map { |key, val| [val, key]}
  end

  def status_value(key)
    Task.human_attribute_name("status.#{key}")
  end

  def priority_value(key)
    Task.human_attribute_name("priority.#{key}")
  end
end
