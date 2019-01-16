# frozen_string_literal: true

module TasksHelper
  def action_names
    if controller.action_name == 'new'
      { action: :create, action_name: 'actions.create' }
    else
      { action: :update, action_name: 'actions.update' }
    end
  end

  def sort_link(column, order)
    order_by = Task::ORDER_BY_VALUES.include?(column) ? column : Task::DEFAULT_ORDER_BY
    order = Task::ORDER_VALUES.to_s.include?(order) ? order : Task::DEFAULT_ORDER
    order_display = 'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
    link_to_if(!match_sort_condition?(column, order), order_display, tasks_path(name: params[:name], status: params[:status], order_by: order_by, order: order))
  end

  private

  def match_sort_condition?(column, order)
    current_order_by = params[:order_by].presence || Task::DEFAULT_ORDER_BY
    current_order = params[:order].presence || Task::DEFAULT_ORDER
    column == current_order_by && order == current_order
  end
end
