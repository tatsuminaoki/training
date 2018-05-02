module TasksHelper

  # Method 'link_sort' : switch desc/asc for link_to sort
  def link_sort label_name
    link_to_elements = ['▼',label_name+' desc', 'sort_'+label_name]
    if params.has_key?(:sort)
      if params[:sort].include?(label_name) && params[:sort].include?('desc')
        link_to_elements[0] = '▲';
        link_to_elements[1] = label_name;
      end
    end
    link_to link_to_elements[0], { sort: link_to_elements[1] }, { id: link_to_elements[2] }
  end

  def current_user_all_labels
    all_labels = []
    current_user.tasks.each do |task|
      task.labels.each do |label|
        all_labels << label if label.present?
      end
    end
    return all_labels.uniq
  end

end
