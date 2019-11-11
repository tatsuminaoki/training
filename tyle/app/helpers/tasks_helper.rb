# frozen_string_literal: true

module TasksHelper
  def switch_asc_and_desc(column)
    if params[:sort] == column && params[:direction] == 'desc'
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'asc'
    else
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'desc'
    end
  end

  def show_asc_or_desc(column)
    if params[:sort] == column && params[:direction] == 'desc' then
      '▼'
    elsif params[:sort] == column && params[:direction] == 'asc' then
      '▲'
    else
      ''
    end
  end
end
