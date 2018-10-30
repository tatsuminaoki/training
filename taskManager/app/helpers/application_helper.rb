module ApplicationHelper
  def sortable(column:, title: nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    css = (column == sort_column) ? "fa fa-sort-#{direction}" : "fa fa-sort"
    # TODO:CSSの切り替えも実施すること
    link_to title, {:sort => column, :direction => direction}, {:class => css}
  end
end
