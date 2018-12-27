# frozen_string_literal: true

module TasksHelper
  def sort_link(column, order)
    order_by = Task::ORDER_BY_VALUES.include?(column) ? column : 'created_at'
    order = Task::ORDER_VALUES.to_s.include?(order) ? order : 'DESC'
    order_display = 'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
    link_to_if(!match_sort_condition(column, order), order_display, tasks_path(order_by: order_by, order: order))
  end

  private

  def match_sort_condition(column, order)
    column == params[:order_by] && order == params[:order]
  end
end
