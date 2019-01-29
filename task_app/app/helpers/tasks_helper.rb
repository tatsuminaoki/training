# frozen_string_literal: true

module TasksHelper
  def sort_link(column_name)
    output = link_to('▲', sort_column: column_name, sort_direction: :asc)
    output << link_to('▼', sort_column: column_name, sort_direction: :desc)
  end
end
