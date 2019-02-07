# frozen_string_literal: true

module UsersHelper
  def sort_users_link(column, order)
    order_by = User::ORDER_BY_VALUES.include?(column) ? column : User::DEFAULT_ORDER_BY
    order = User::ORDER_VALUES.to_s.include?(order) ? order : User::DEFAULT_ORDER
    order_display = 'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
    link_to_if(!match_sort?(column, order), order_display, order_by: order_by, order: order)
  end

  def sort_user_tasks_link(column, order)
    order_by = Task::ORDER_BY_VALUES.include?(column) ? column : Task::DEFAULT_ORDER_BY
    order = Task::ORDER_VALUES.to_s.include?(order) ? order : Task::DEFAULT_ORDER
    order_display = 'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
    link_to_if(!match_sort?(column, order), order_display, admin_user_path(name: params[:name], status: params[:status], order_by: order_by, order: order, label_ids: params[:label_ids]))
  end

  private

  def match_sort?(column, order)
    current_order_by = params[:order_by].presence || User::DEFAULT_ORDER_BY
    current_order = params[:order].presence || User::DEFAULT_ORDER
    column == current_order_by && order == current_order
  end
end
