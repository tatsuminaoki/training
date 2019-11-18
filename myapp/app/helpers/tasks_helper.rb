# frozen_string_literal: true

module TasksHelper
  def link_sort_by(params, sort_column)
    order = params[:order].present? && params[:order] == 'desc' ? 'asc' : 'desc'
    link_to "#{t sort_column.to_sym}:#{t order.to_sym}", root_path(name: params[:name], status: params[:status], sort_column: sort_column.to_s, order: order)
  end
end
