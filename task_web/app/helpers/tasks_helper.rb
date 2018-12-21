# frozen_string_literal: true

module TasksHelper
  def sort_link(column, order)
    @order = 'ASC'.casecmp?(order) ? 'ASC' : 'DESC'
    @name = 'ASC'.casecmp?(order) ? I18n.t('links.ASC') : I18n.t('links.DESC')
    @order_by = Task.column_names.include?(column) ? column : 'created_at'
    link_to_if(match_sort_condition(column, order), @name, tasks_path(order_by: @order_by, order: @order))
  end

  private

  def match_sort_condition(column, order)
    !(column == params[:order_by] && order == params[:order])
  end
end
