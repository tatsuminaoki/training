module ApplicationHelper
  def sortable(column, title, search_params = [])
    css_class = (column == sort_column) ? "current_#{sort_order}" : nil
    order = (column == sort_column && sort_order == "asc") ? "desc" : "asc"
    params = { :sort => column, :order => order }
    params = search_params.merge(params) if search_params.present?
    link_to title, params, { :class => css_class }
  end
end
