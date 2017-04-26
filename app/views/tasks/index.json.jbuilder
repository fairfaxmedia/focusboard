json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description, :status, :user_id
  json.url task_url(task, format: :json)
end
