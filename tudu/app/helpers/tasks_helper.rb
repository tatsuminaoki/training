module TasksHelper
  def display_label(task)
    task.labels.pluck(:name).join(' / ')
  end
end
