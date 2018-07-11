module PrepareTasksMacros
  def prepare_ordered_tasks(order)
    ordered_tasks = Task.all.order(order)
    tasks = []
    ordered_tasks.each do |t|
      tasks << '期限：' + t.due_date.to_s
      tasks << '状態：' + I18n.t("status.#{t.status}")
      tasks << '優先度：' + I18n.t("priority.#{t.priority}")
    end
    tasks
  end
end
