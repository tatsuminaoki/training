# frozen_string_literal: true

module TasksHelper
  def link_sort(label_name)
    if params[:sort] == 'asc'
      link_to label_name, root_path(sort: 'desc')
    else
      link_to label_name, root_path(sort: 'asc')
    end
  end
end
