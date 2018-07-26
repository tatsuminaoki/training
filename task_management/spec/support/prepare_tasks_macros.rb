module PrepareTasksMacros
  def prepare_ordered_tasks(order)
    ordered_tasks = Task.all.order(order)
    tasks = ["#{@user.user_name}\nログアウト"]
    ordered_tasks.each do |t|
      tasks << '期限：' + t.due_date.to_s
      tasks << '状態：' + I18n.t("status.#{t.status}")
      tasks << '優先度：' + I18n.t("priority.#{t.priority}")
      tasks << I18n.t('view.labels', :labels => labels_associated_with_task(t))
    end
    tasks
  end

  def labels_associated_with_task(task)
    label_types = LabelType.eager_load(:labels)
    labels = []
    label_types.each do |label_type|
      labels << label_type.label_name if label_type.task_ids.include?(task.id)
    end
    labels
  end
end
