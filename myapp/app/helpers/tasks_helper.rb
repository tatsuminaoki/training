module TasksHelper
  def tasks_sort(column_name, val)
    request.fullpath.include?('desc') ? link_to(column_name, sort: val) : link_to(column_name, sort: "#{val} desc")
  end
end
