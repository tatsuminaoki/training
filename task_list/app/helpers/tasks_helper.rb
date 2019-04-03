module TasksHelper
  def label_names
    Label.all.map.each do |label|
    label.name
    end
  end
end
