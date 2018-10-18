module ListHelper
  def task_status_message(status)
    # TODO: タグ表示する
    t status, scope: "enum.task.status"
  end

  def task_priority_message(priority)
    # TODO: タグ表示する
    t priority, scope: "enum.task.priority"
  end

  def label_message(label_name)
    %(<p>#{label_name}</p>).html_safe
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
