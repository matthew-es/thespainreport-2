class Account < ApplicationRecord
    belongs_to :user, optional: true
    has_many :users
    has_many :invoices
    has_many :subscriptions
    has_many :payments
end
