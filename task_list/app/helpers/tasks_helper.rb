module TasksHelper
  def label_names
    current_user.labels.all.map.each do |label|
    label.name
    end
  end
end
