class Subscription < ApplicationRecord
    has_many :invoices
    has_many :payments
    belongs_to :frame
    belongs_to :account
end
