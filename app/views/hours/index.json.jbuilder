json.array!(@hours) do |hour|
  json.extract! hour, :id, :client, :project, :date, :hours
  json.url hour_url(hour, format: :json)
end
