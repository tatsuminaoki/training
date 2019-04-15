module ApplicationHelper
  def sortable(column, title, search_model = nil)
    css_class = (column == sort_column) ? "current_#{sort_order}" : nil
    order = (column == sort_column && sort_order == "asc") ? "desc" : "asc"
    params = { :sort => column, :order => order }

    if search_model.present? && search_model.get_condition.present?
      params = search_model.get_condition.merge(params)
    end

    link_to title, params, { :class => css_class }
  end
end
