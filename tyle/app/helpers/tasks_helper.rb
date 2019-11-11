# frozen_string_literal: true

module TasksHelper
  def switch_asc_and_desc(column)
    if params[:sort] == column && params[:direction] == 'asc'
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'desc'
    else
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'asc'
    end
  end

  def show_asc_or_desc(column)
    default_of_created_at = (column == 'created_at' && params[:sort].nil? && params[:direction].nil?)
    if default_of_created_at
      '▼'
    elsif params[:sort] == column && params[:direction] == 'desc'
      '▼'
    elsif params[:sort] == column && params[:direction] == 'asc'
      '▲'
    else
      ''
    end
  end
end
