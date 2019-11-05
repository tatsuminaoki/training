# frozen_string_literal: true

module TasksHelper
  def switch_asc_and_desc(column)
    if params[:sort] == column && params[:direction] == 'desc'
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'asc', search: params[:search], priority: params[:priority], status: params[:status] 
    else
      link_to t("activerecord.attributes.task.#{column}"), sort: column, direction: 'desc', search: params[:search], priority: params[:priority], status: params[:status] 
    end
  end
end
