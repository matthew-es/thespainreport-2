class Subscription < ApplicationRecord
    has_many :invoices
    has_many :payments
    has_many :users
    belongs_to :frame
    belongs_to :account
    
    scope :active, -> {where(is_active: true)}
	scope :amount_active, -> {where('plan_amount > ?', 0)}
	scope :amount_zero, -> {where(plan_amount: 0)}
	scope :amount_blank, -> {where(plan_amount: "")}
	scope :payment_now, -> {where(next_payment_date: DateTime.now.in_time_zone.beginning_of_hour..DateTime.now.in_time_zone.end_of_hour)}
end
