module ListHelper
  def task_status_message(status)
    Task::TASK_STATUSES[status]
  end

  def task_priority_message(priority)
    Task::TASK_PRIORITIES[priority]
  end

  def label_message(label_name)
    %(<p>#{label_name}</p>).html_safe
  end

  def description_message(description)
    %(<pre>#{description}</pre>).html_safe
  end

  def hash_task_priorities
    Task::TASK_PRIORITIES.invert
  end

  def hash_task_statuses
    Task::TASK_STATUSES.invert
  end

  def action_contents
    if controller.action_name == 'new' || controller.action_name == 'create'
      { flag_entry: true, action: :create, action_name: '登録' }
    else
      { flag_entry: false, action: :update, action_name: '編集' }
    end
  end
end
