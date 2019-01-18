json.extract! upload, :id, :data, :created_at, :updated_at
json.url upload_url(upload, format: :json)
