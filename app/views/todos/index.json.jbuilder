json.array!(@todos) do |todo|
  json.extract! todo, :id, :task, :complete
  json.url todo_url(todo, format: :json)
end
