module ApplicationHelper
  def status_name(status)
    if status == 0
      t('page.task.status.open')
    elsif status == 1
      t('page.task.status.inprogress')
    else
      t('page.task.status.done')
    end
  end

  def priority_name(priority)
    if priority == 0
      t('page.task.priority.low')
    elsif priority == 1
      t('page.task.priority.middle')
    else
      t('page.task.priority.high')
    end
  end
end
