json.extract! invoice, :id, :tax_percent, :plan_amount, :tax_amount, :total_amount, :account_id, :subscription_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
