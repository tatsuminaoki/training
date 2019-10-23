module ApplicationHelper
  # Return complete title for each page.
  def full_title(page_title = '')
    base_title = 'Task Management App'
    if page_title.empty?
      base_title
    else
      page_title + '|' + base_title
    end
  end

  # Return if the direction of the column is selected or not.
  def is_sorted(column, direction)
    if column == sort_column && direction == sort_direction
      'on'
    else
      'off'
    end
  end
end
