# frozen_string_literal: true

module TasksHelper
  def sort_icon(self_column, search_form)
    if search_form.direction && self_column == search_form.sort_column.to_sym
      if search_form.direction == 'asc'
        '▲'
      else
        '▼'
      end
    else
      ''
    end
  end
end
