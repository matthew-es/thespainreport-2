class Payment < ApplicationRecord
	require 'stripe'
	
	belongs_to :account, optional: true
	belongs_to :subscription, optional: true
	has_many :payment_errors
	has_many :invoices
	
	STATUSES = %i[paid refund problem]
	TYPES = %I[first repeat fix reactivate increase]
end