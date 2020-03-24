# frozen_string_literal: true

class TaskSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :priority, :string
  attribute :status, :string
  attribute :sort_column, :string
  attribute :direction, :string

  def search
    Task.search_with_priority(priority)
        .search_with_status(status)
        .match_with_title(title)
        .sort_by_column(sort_column, direction)
  end
end
