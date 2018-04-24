module ApplicationHelper
  def sortable(clazz, column, title = nil)
    title ||= column.titleize

    order = (column == sort_column(clazz, column) && sort_order == 'asc') ? 'asc' : 'desc'
    to_order = (column == sort_column(clazz, column) && sort_order == 'asc') ? 'desc' : 'asc'
    css_class = (column == sort_column(clazz, column)) ? "current #{order}" : order

    title += (order == 'asc') ? ' ▲' : ' ▼'
    link_to title, params.permit(:sort, :order, :keyword, :task, :status).merge({sort: column, order: to_order}), {class: css_class}
  end
end
