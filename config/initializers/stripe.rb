if Rails.env.development?
    Rails.application.credentials.dig(:stripe, :secret_key_development)
elsif Rails.env.production?
    Rails.application.credentials.dig(:stripe, :secret_key_production)
else end