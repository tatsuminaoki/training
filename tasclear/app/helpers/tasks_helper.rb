# frozen_string_literal: true

module TasksHelper
  def link_sort(label_name, category)
    sort = if params[:sort] == 'desc'
             'asc'
           elsif params[:sort] == 'asc'
             'desc'
           elsif category == 'deadline'
             'asc'
           else
             'desc'
           end
    link_to label_name, root_path(sort: sort, category: category)
  end
end
