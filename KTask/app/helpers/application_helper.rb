# frozen_string_literal: true

module ApplicationHelper
  def sort(column, title = nil)
    title ||= t('.' + column)
    # ソートの状態を比較する
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, sort: column, direction: direction
  end
end
