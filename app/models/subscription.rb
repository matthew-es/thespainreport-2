class Subscription < ApplicationRecord
    has_many :invoices
    has_many :payments
    has_many :users
    belongs_to :frame
    belongs_to :account
end
