class WebhookEvent < ApplicationRecord
    enum state: { pending: 0, processing: 1, success: 2, failed: 3 }
end
