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
    scope = Task.all
    scope = scope.search_with_priority(priority)
    scope = scope.search_with_status(status)
    scope = scope.match_with_title(title)
    sort(scope)
  end

  def sort(scope)
    scope.sort_by_column(sort_column, direction)
  end
end
