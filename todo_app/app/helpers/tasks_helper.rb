module TasksHelper
  def submit_btn_name
    puts request.path_info
    puts request.url
    if request.path_info == new_task_path
      return I18n.t('helpers.submit.create')
    else
      return I18n.t('helpers.submit.update')
    end
  end

  def status_pull_down
    StatusType.all.map do |key|
      [StatusType.human_attribute_name(key), key]
    end
  end

  def priority_pull_down
    PriorityType.all.map { |key| [PriorityType.human_attribute_name(key), key] }
  end
end
