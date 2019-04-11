module ApplicationHelper
  def sortable(column, title)
    css_class = (column == sort_column) ? "current_#{sort_order}" : nil
    order = (column == sort_column && sort_order == "asc") ? "desc" : "asc"
    link_to title, { :sort => column, :order => order }, { :class => css_class }
  end
end
