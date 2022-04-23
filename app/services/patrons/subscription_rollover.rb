module Patrons
	class SubscriptionRollover
		def self.process(subscription, payment)
			
			time_now = Time.zone.now
			
			case subscription.payment_period when "month" then subs_next_payment_date = time_now + 1.month
			when "year" then subs_next_payment_date = time_now + 1.year
			when "one_time"
				how_many_months = subscription.plan_amount/100/10
				subs_next_payment_date = time_now + how_many_months.months
			end

			existing_next_dates = []
			subscription.account.subscriptions.each do |s|
			 existing_next_dates << s.next_payment_date	
			end
			existing_max_next_payment_date = existing_next_dates.max
			
			existing_max_next_payment_date > subs_next_payment_date ? rollover_next_payment_date = existing_max_next_payment_date : rollover_next_payment_date = subs_next_payment_date
			
			subscription.update(
				is_active: true,
				last_payment_date: payment.created_at,
				next_payment_date: rollover_next_payment_date,
				reactivate_token: SecureRandom.urlsafe_base64.to_s
				)
			
			Patrons::SubscriptionUpdateUsers.process(subscription, subscription.plan_amount)
		
			subscription

		end
	end
end