module ListHelper
  def task_status_message(status)
    status_str = I18n.t status, scope: "enum.task.status"
    case status
    when "waiting" then
      label_str = "label-success"
    when "working" then
      label_str = "label-primary"
    else
      label_str = "label-danger"
    end

    %(<span class="label #{label_str}">#{status_str}</span>).html_safe
  end

  def task_priority_message(priority)
    priority_str = I18n.t priority, scope: "enum.task.priority"
    case priority
    when "low" then
      label_str = "label-success"
    when "common" then
      label_str = "label-primary"
    else
      label_str = "label-danger"
    end
    %(<span class="label #{label_str}">#{priority_str}</span>).html_safe
  end

  def label_message(label_name)
    %(<span class="label label-warning">#{label_name}</span>).html_safe
  end

  def description_message(description)
    %(<pre>#{description}</pre>).html_safe
  end

  def action_contents
    if controller.action_name == 'new' || controller.action_name == 'create'
      { action: :create, action_name: "actions.new" }
    else
      { action: :update, action_name: "actions.edit" }
    end
  end
end
