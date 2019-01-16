json.extract! article, :id, :headline, :lede, :body, :created_at, :updated_at
json.url article_url(article, format: :json)
