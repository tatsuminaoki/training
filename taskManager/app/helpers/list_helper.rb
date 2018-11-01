module ListHelper
  def task_status_message(status)
    status_str = I18n.t status, scope: "enum.task.status"
    raw %(<span class="label label-#{status}">#{status_str}</span>)
  end

  def task_priority_message(priority)
    priority_str = I18n.t priority, scope: "enum.task.priority"
    raw %(<span class="label label-#{priority}">#{priority_str}</span>)
  end

  def label_message(label_name)
    raw %(<span class="label label-warning">#{label_name}</span>)
  end

  def description_message(description)
    raw %(<pre>#{description}</pre>)
  end

  def action_contents
    if controller.action_name == 'new' || controller.action_name == 'create'
      { action: :create, action_name: "actions.new" }
    else
      { action: :update, action_name: "actions.edit" }
    end
  end
end
