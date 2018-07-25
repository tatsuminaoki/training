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

  def priority_color(priority)
    if priority == 'high'
      'danger'
    elsif priority == 'middle'
      'warning'
    else
      'success'
    end
  end

  def border_color(deadline)
    left_days = (deadline - Time.zone.today).to_i
    if left_days <= 1
      'danger'
    elsif left_days <= 7
      'warning'
    end
  end

  def cell_color(number)
    target_day = Time.zone.today - number
    Task.all.each do |task|
      return 'success' if task.updated_at.to_date == target_day
    end
  end
end
