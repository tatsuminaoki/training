module ListHelper
  TASK_STATUSES = {
    Task::STATUS_WAITING => '未着手',
    Task::STATUS_WORKING => '着手',
    Task::STATUS_COMPLETED => '完了'
  }.freeze

  TASK_PRIORITIES = {
    Task::PRIORITY_LOW => '低',
    Task::PRIORITY_COMMON => '中',
    Task::PRIORITY_HIGH => '高'
  }.freeze

  def task_status_message(status)
    status_message = TASK_STATUSES[status]
    %(#{status_message}).html_safe
  end

  def task_priority_message(priority)
    priority_message = TASK_PRIORITIES[priority]
    %(#{priority_message}).html_safe
  end

  def label_message(label_name)
    %(<p>#{label_name}</p>).html_safe
  end

  def description_message(description)
    %(<pre>#{description}</pre>).html_safe
  end

  def hash_task_priorities
    TASK_PRIORITIES.invert
  end

  def hash_task_statuses
    TASK_STATUSES.invert
  end

  def action_contents
    if controller.action_name == 'entry' || controller.action_name == 'insert'
      { flag_entry: true, action: :insert, action_name: '登録' }
    else
      { flag_entry: false, action: :update, action_name: '編集' }
    end
  end
end
