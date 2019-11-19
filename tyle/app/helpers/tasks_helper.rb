# frozen_string_literal: true

module TasksHelper
  def switch_asc_and_desc(column, sort_column, sort_direction)
    if sort_column == column && sort_direction == 'asc'
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'desc', name: params[:name], priority: params[:priority], status: params[:status]
    else
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'asc', name: params[:name], priority: params[:priority], status: params[:status]
    end
  end

  def show_asc_or_desc(column, sort_column, sort_direction)
    if sort_column == column && sort_direction == 'desc'
      '▼'
    elsif sort_column == column && sort_direction == 'asc'
      '▲'
    else
      ''
    end
  end
end
