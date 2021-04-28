class Invoice < ApplicationRecord
    belongs_to :subscription
    belongs_to :account
    belongs_to :payment, optional: true
    
    has_many :operations, class_name: "Invoice", foreign_key: "original_id"
    belongs_to :original, class_name: "Invoice", optional: true
    
    TYPES = %i[full simple correction]
    OPERATIONS = %i[payment exchange refund error]
    
end
