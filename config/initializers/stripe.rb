if Rails.env.development?
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key_development)
elsif Rails.env.production?
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key_production)
else end