json.extract! subscription, :id, :account_id, :amount, :card_country, :latest_paid_date, :ip_country, :ip_address, :residence_country, :created_at, :updated_at
json.url subscription_url(subscription, format: :json)
