json.extract! task, :id, :title, :description, :due_at, :concluded, :concluded_at, :user_id, :created_at, :updated_at
json.url task_url(task, format: :json)
