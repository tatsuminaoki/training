# frozen_string_literal: true

module TaskHelper
  def sort_asc(column_name)
    link_to '▲', { column: column_name, direction: 'asc' }, id: column_name.dasherize + '-asc'
  end

  def sort_desc(column_name)
    link_to '▼', { column: column_name, direction: 'desc' }, id: column_name.dasherize + '-desc'
  end

  def sort_direction
    # If params[:direction] is nil, set sort_direction to 'desc' by default
    %W[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    # If params[:column] is nil, set sort_column to 'created_date' by default
    Task.column_names.include?(params[:column]) ? params[:column] : 'created_at'
  end
end
