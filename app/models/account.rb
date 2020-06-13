class Account < ApplicationRecord
    belongs_to :user, optional: true
    has_many :users
    has_many :invoices
    has_many :subscriptions
    has_many :payments
    
    scope :uptodate, -> {where(account_status: 1)}
    scope :declined, -> {where(account_status: 2)}
    scope :cancelled, -> {where(account_status: 3)}
    scope :free, -> {where(account_status: 4)}
end
