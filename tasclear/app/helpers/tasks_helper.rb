# frozen_string_literal: true

module TasksHelper
  def link_sort(label_name, sort_category)
    # 現在ソートしているカテゴリーと同じカテゴリーが選択される場合はソート順を逆にする
    sort_direction = if params[:sort_category] == sort_category
                       if params[:sort_direction] == 'desc'
                         'asc'
                       else
                         'desc'
                       end
                       # 現在ソートしていないカテゴリーが選択される場合は、終了期限：昇順、優先度：降順とする
                     elsif sort_category == 'deadline'
                       'asc'
                     else
                       'desc'
                     end
    link_to label_name, root_path(sort_direction: sort_direction, sort_category: sort_category)
  end

  def status_color(status)
    if status == 'to_do'
      'light'
    elsif status == 'doing'
      'primary'
    else
      'dark'
    end
  end
end
