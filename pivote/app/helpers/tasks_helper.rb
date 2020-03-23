# frozen_string_literal: true

module TasksHelper
  def sort_icon(self_column, search_form)
    if search_form.direction && self_column == search_form.sort_column.to_sym
      if search_form.direction == 'asc'
        '▲'
      else
        '▼'
      end
    else
      ''
    end
  end

  def sort_params(search_form_hash, next_sort_column)
    # ソートするカラムのリンクを踏む度に、「desc → asc → デフォルト(作成日時の降順) → desc …」と並び変わる
    if search_form_hash['sort_column'] == next_sort_column.to_s
      if search_form_hash['direction'] == 'asc'
        search_form_hash['sort_column'] = nil
        search_form_hash['direction'] = nil
      else
        search_form_hash['sort_column'] = next_sort_column
        search_form_hash['direction'] = 'asc'
      end
    else
      search_form_hash['sort_column'] = next_sort_column
      search_form_hash['direction'] = 'desc'
    end
    search_form_hash
  end
end
