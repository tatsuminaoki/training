class LogicBoard
  require 'task'

  def index(user_id)
    return {
      'task_list'     => Task.where(user_id: user_id),
      'state_list'    => get_state_list,
      'priority_list' => get_priority_list,
      'label_list'    => get_label_list,
    }
  end

  def get_task_all(user_id)
    return {
      'task_list' => Task.where(user_id: user_id),
    }
  end

  def get_task_by_id(user_id, id)
    return {
      'task' => Task.find(id),
    }
  end

  def get_state_list
    return {
      1 => 'Open',
      2 => 'Doing',
      3 => 'Done',
      4 => 'Pending',
      5 => 'Close'
    }
  end

 def get_priority_list
    return {
      1 => 'Low',
      2 => 'Middle',
      3 => 'High',
    }
  end

  def get_label_list
    return {
      1 => 'Bugfix',
      2 => 'Support',
      3 => 'Research',
      4 => 'Implement',
      5 => 'Other'
    }
  end

  def create(user_id, params)
    task = Task.new(
      user_id:     user_id,
      subject:     params['subject'],
      description: params['description'],
      state:       1,
      priority:    params['priority'],
      label:       params['label']
    )
    return task.save
  end

  def update(user_id, params)
    task = Task.find_by_id(params['id'])
    if task.nil?
      return false
    end
    if task.user_id != user_id
      return false
    end
    task.subject     = params['subject']
    task.description = params['description']
    task.priority    = params['priority']
    task.state       = params['state']
    return task.save
  end

  def delete(user_id, id)
    task = Task.find_by_id(id)
    if task.nil?
      return false
    end
    if task.user_id != user_id
      return false
    end
    return task.delete
  end
end
