module TasksHelper
  def submit_btn_name
    puts request.path_info
    puts request.url
    if request.path_info == new_task_path
      return '登録'
    else
      return '更新'
    end
  end
end
