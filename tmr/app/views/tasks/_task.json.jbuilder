json.extract! task, :id, :user_id, :title, :description, :status, :priority, :due_date, :start_date, :finished_date, :created_at, :updated_at
json.url task_url(task, format: :json)
