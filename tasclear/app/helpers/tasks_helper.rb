# frozen_string_literal: true

module TasksHelper
  def link_sort_deadline(label_name)
    if params[:sort_deadline] == 'asc'
      link_to label_name, root_path(sort_deadline: 'desc')
    else
      link_to label_name, root_path(sort_deadline: 'asc')
    end
  end

  def link_sort_priority(label_name)
    if params[:sort_priority] == 'desc'
      link_to label_name, root_path(sort_priority: 'asc')
    else
      link_to label_name, root_path(sort_priority: 'desc')
    end
  end
end
