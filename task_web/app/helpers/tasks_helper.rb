# frozen_string_literal: true

module TasksHelper
  def sort_tasks_link(column, order)
    order_by = Task::ORDER_BY_VALUES.include?(column) ? column : Task::DEFAULT_ORDER_BY
    order = Task::ORDER_VALUES.to_s.include?(order) ? order : Task::DEFAULT_ORDER
    link_to_if(!match_sort?(column, order), order_display(order),
               tasks_path(name: params[:name], status: params[:status], order_by: order_by, order: order, label_ids: params[:label_ids]))
  end

  private

  def order_display(order)
    'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
  end

  def match_sort?(column, order)
    current_order_by = params[:order_by].presence || Task::DEFAULT_ORDER_BY
    current_order = params[:order].presence || Task::DEFAULT_ORDER
    column == current_order_by && order == current_order
  end
end
