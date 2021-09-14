class Payment < ApplicationRecord
	require 'stripe'
	
	belongs_to :account, optional: true
	belongs_to :subscription, optional: true
	has_many :payment_errors
	has_many :invoices
	
	STATUSES = %i[paid refunded problem]
	TYPES = %i[first repeat fix reactivate increase]
	PERIODS = %i[month year one_time]
end