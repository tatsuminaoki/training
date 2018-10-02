# frozen_string_literal: true

module TasksHelper
  def toggled_sort_link(column, title = nil)
    title ||= t('.' + column)
    # ソートの状態を比較する
    if params[:direction] == 'asc'
      link_to title, sort: column, direction: 'desc'
    else
      link_to title, sort: column, direction: 'asc'
    end
  end
end
