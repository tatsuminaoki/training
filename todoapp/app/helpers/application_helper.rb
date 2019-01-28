module ApplicationHelper
  # ソート用のClickableなリンクを作る
  def sortable(column, title = nil)
    title ||= column.titleize

    direction = 'asc'
    if column == sort_column && sort_direction == 'asc'
      direction = 'desc'
    end

    link_to title, {:sort => column, :direction => direction}
  end
end
