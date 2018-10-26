# frozen_string_literal: true

module TasksHelper
  def toggled_sort_link(column, title = nil)
    title ||= t('.' + column)
    # ソートの状態を比較する
    direction = (params[:sort] == column && params[:direction] == 'asc') ? 'desc' : 'asc'
    link_to title, sort: column, direction: direction
  end

  def priority_color(priority)
    case priority
    when 2 then
      'danger'
    when 1 then
      'warning'
    when 0 then
      'success'
    end
  end

  def status_color(status)
    case status
    when 2 then
      'secondary'
    when 1 then
      'success'
    when 0 then
      'primary'
    end
  end
end
