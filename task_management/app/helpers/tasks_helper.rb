module TasksHelper
  def labels_associated_with_task(task_id)
    label_ids = Label.where(task_id: task_id).pluck(:label_type_id)
    @labels = LabelType.where(id: label_ids).pluck(:label_name)
  end
end
