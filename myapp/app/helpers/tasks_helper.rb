module TasksHelper
  def tasks_sort(n, val)
    request.fullpath.include?('desc') ? link_to(n, sort: val) : link_to(n, sort: "#{val} desc")
  end
end
