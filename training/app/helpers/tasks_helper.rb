module TasksHelper
  def label_name(label_id)
    label = Label.find_by(id: label_id)
    label.present? ? label.name : '-'
  end
end
