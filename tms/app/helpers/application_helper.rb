module ApplicationHelper
  def status_name(status)
    if status == 0
      %{<span class="label label-primary">#{t('page.task.status.open')}</span>}.html_safe
    elsif status == 1
      %{<span class="label label-warning">#{t('page.task.status.inprogress')}</span>}.html_safe
    else
      %{<span class="label label-success">#{t('page.task.status.done')}</span>}.html_safe
    end
  end

  def priority_name(priority)
    if priority == 0
      %{<span class="label label-success">#{t('page.task.priority.low')}</span>}.html_safe
    elsif priority == 1
      %{<span class="label label-warning">#{t('page.task.priority.middle')}</span>}.html_safe
    else
      %{<span class="label label-danger">#{t('page.task.priority.high')}</span>}.html_safe
    end
  end
end
