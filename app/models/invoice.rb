class Invoice < ApplicationRecord
    belongs_to :subscription
    belongs_to :account
    has_many :payments
end
