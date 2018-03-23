# frozen_string_literal: true

module TasksHelper
  def submit_btn_name
    return I18n.t('helpers.submit.create') if request.path_info == new_task_path
    I18n.t('helpers.submit.update')
  end

  def status_pull_down
    Task.statuses.keys.map { |key| [status_value(key), key] }
  end

  def status_pull_down_with_all
    [['', 'all']] | status_pull_down
  end

  def priority_pull_down
    Task.priorities.keys.map { |key| [priority_value(key), key] }
  end

  def sort_pull_down
    Task::SORT_KINDS.map { |key| [Task.human_attribute_name("sort_kinds.#{key}"), key] }
  end

  def status_value(key)
    Task.human_attribute_name("statuses.#{key}")
  end

  def priority_value(key)
    Task.human_attribute_name("priorities.#{key}")
  end

  def status_badge(key)
    case key
    when Task.statuses.keys[0]
      'badge-warning'
    when Task.statuses.keys[1]
      'badge-info'
    when Task.statuses.keys[2]
      'badge-success'
    end
  end
end
