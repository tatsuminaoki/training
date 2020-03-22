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
    scope = scope.search_with_priority(priority) if priority.present?
    scope = scope.search_with_status(status) if status.present?
    scope = scope.match_with_title(title) if title.present?
    sort(scope)
  end

  def sort(scope)
    # ソートするカラムのリンクを踏む度に、「desc → asc → デフォルト(作成日時の降順) → desc …」と並び変わる
    if !sort_column || direction == 'asc'
      self.direction = nil
      scope.by_default
    else
      self.direction = direction.present? ? 'asc' : 'desc'
      scope.by_custom(sort_column, direction)
    end
  end
end
