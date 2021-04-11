class Invoice < ApplicationRecord
    belongs_to :subscription
    belongs_to :account
    belongs_to :payment, optional: true
    
    TYPES = %i[full simple correction]
    OPERATIONS = %i[payment exchange refund error]
    
end
