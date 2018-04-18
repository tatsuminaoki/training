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
    link_to link_to_elements[0], { sort: link_to_elements[1] }, { :id => link_to_elements[2] }
  end

end
