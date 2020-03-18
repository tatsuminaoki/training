# frozen_string_literal: true

module TasksHelper
  # 表示するべきソート用アイコンを返す
  # === 引数
  # * self_column - このカラムにソートアイコンを表示する
  # * sorted_column - 現在このカラムでソートされている
  # * direction - 現在この順番でソートされている
  def sort_icon(self_column, sorted_column, direction)
    if direction && self_column == sorted_column.to_sym
      if direction == 'asc'
        '▲'
      else
        '▼'
      end
    else
      ''
    end
  end
end
