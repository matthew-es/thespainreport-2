json.extract! user, :id, :email, :email_confirmed, :password_digest, :role, :confirm_token, :created_at, :updated_at
json.url user_url(user, format: :json)
