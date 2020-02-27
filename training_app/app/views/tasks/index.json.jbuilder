json.data do
  json.current_page @tasks.current_page
  json.total_page @tasks.total_pages

  json.tasks do 
    json.array! @tasks do |task|
      json.id task.id
      json.title task.title
      json.user_id task.user_id
      json.name task.user&.name
      json.status task.status_name
    end
  end
end
