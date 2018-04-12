module ApplicationHelper
  def status_flg(sts)
    if sts == 0
      return %{#{t("page.task.status.open")}}.html_safe
    elsif sts == 1
      return %{#{t("page.task.status.inprogress")}}.html_safe
    else
      return %{#{t("page.task.status.done")}}.html_safe
    end
  end

  def priority_flg(priority)
    if priority == 0
      return %{#{t("page.task.priority.low")}}.html_safe
    elsif priority == 1
      return %{#{t("page.task.priority.middle")}}.html_safe
    else
      return %{#{t("page.task.priority.high")}}.html_safe
    end
  end
end
