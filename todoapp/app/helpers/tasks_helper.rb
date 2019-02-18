module TasksHelper
  def task_label(task)
    task.labels.map { |label| [label.name] }.join('/')
  end
end
