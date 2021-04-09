class Invoice < ApplicationRecord
    belongs_to :subscription
    belongs_to :account
    has_many :payments
    
    TYPES = %i[full simple correction]
    OPERATIONS = %i[payment exchange refund error]
    
end
