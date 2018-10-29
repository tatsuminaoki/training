module ApplicationHelper
  def sortable(column:, title: nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    # TODO:CSSの切り替えも実施すること
    link_to title, {:sort => column, :direction => direction}
  end
end
